/**
 * api.js — Shared AJAX fetch library for Azure Resort dashboard
 * Provides: api.get(), api.post(), toast notifications, spinner helpers
 */
(function (global) {
    'use strict';

    // ── Toast System ─────────────────────────────────────────────
    let _toastContainer = null;

    function _ensureContainer() {
        if (_toastContainer) return _toastContainer;
        _toastContainer = document.createElement('div');
        _toastContainer.id = 'api-toast-container';
        _toastContainer.style.cssText = [
            'position:fixed', 'top:20px', 'right:20px', 'z-index:9999',
            'display:flex', 'flex-direction:column', 'gap:10px',
            'pointer-events:none', 'max-width:360px'
        ].join(';');
        document.body.appendChild(_toastContainer);
        return _toastContainer;
    }

    /**
     * Show a toast notification.
     * @param {string} message
     * @param {'success'|'error'|'warn'|'info'} type
     * @param {number} duration ms (default 3500)
     */
    function toast(message, type, duration) {
        type = type || 'info';
        duration = duration || 3500;
        var container = _ensureContainer();

        var colors = {
            success: { bg: 'rgba(74,222,128,0.12)', border: 'rgba(74,222,128,0.35)', text: '#4ade80' },
            error:   { bg: 'rgba(248,113,113,0.12)', border: 'rgba(248,113,113,0.35)', text: '#f87171' },
            warn:    { bg: 'rgba(251,191,36,0.12)', border: 'rgba(251,191,36,0.35)', text: '#fbbf24' },
            info:    { bg: 'rgba(96,165,250,0.12)', border: 'rgba(96,165,250,0.35)', text: '#60a5fa' }
        };
        var icons = { success: '✅', error: '❌', warn: '⚠️', info: 'ℹ️' };
        var c = colors[type] || colors.info;

        var el = document.createElement('div');
        el.style.cssText = [
            'background:' + c.bg,
            'border:1px solid ' + c.border,
            'color:' + c.text,
            'padding:12px 16px',
            'border-radius:12px',
            'font-family:Inter,sans-serif',
            'font-size:13.5px',
            'font-weight:500',
            'display:flex',
            'align-items:center',
            'gap:10px',
            'pointer-events:auto',
            'cursor:pointer',
            'backdrop-filter:blur(12px)',
            'box-shadow:0 4px 24px rgba(0,0,0,0.4)',
            'opacity:0',
            'transform:translateX(20px)',
            'transition:opacity 0.25s,transform 0.25s'
        ].join(';');
        el.innerHTML = '<span>' + icons[type] + '</span><span>' + message + '</span>';
        el.addEventListener('click', function () { _removeToast(el); });
        container.appendChild(el);

        // Animate in
        requestAnimationFrame(function () {
            requestAnimationFrame(function () {
                el.style.opacity = '1';
                el.style.transform = 'translateX(0)';
            });
        });

        // Auto-remove
        var timer = setTimeout(function () { _removeToast(el); }, duration);
        el._timer = timer;
    }

    function _removeToast(el) {
        clearTimeout(el._timer);
        el.style.opacity = '0';
        el.style.transform = 'translateX(20px)';
        setTimeout(function () { if (el.parentNode) el.parentNode.removeChild(el); }, 280);
    }

    // ── Spinner ──────────────────────────────────────────────────
    var _spinnerEl = null;

    function showSpinner(container) {
        if (container) {
            container.style.position = 'relative';
            var s = document.createElement('div');
            s.className = 'api-spinner-inline';
            s.style.cssText = 'display:flex;align-items:center;justify-content:center;padding:40px;';
            s.innerHTML = '<div style="width:32px;height:32px;border:3px solid rgba(201,168,76,0.2);border-top-color:#c9a84c;border-radius:50%;animation:api-spin 0.7s linear infinite"></div>';
            container.appendChild(s);
            _ensureSpinnerStyle();
            return s;
        }
        // Global overlay spinner
        if (_spinnerEl) return _spinnerEl;
        _ensureSpinnerStyle();
        _spinnerEl = document.createElement('div');
        _spinnerEl.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.4);z-index:8888;display:flex;align-items:center;justify-content:center;backdrop-filter:blur(2px)';
        _spinnerEl.innerHTML = '<div style="width:44px;height:44px;border:4px solid rgba(201,168,76,0.2);border-top-color:#c9a84c;border-radius:50%;animation:api-spin 0.7s linear infinite"></div>';
        document.body.appendChild(_spinnerEl);
        return _spinnerEl;
    }

    function hideSpinner(el) {
        var target = el || _spinnerEl;
        if (target && target.parentNode) target.parentNode.removeChild(target);
        if (!el) _spinnerEl = null;
    }

    function _ensureSpinnerStyle() {
        if (document.getElementById('api-spin-style')) return;
        var style = document.createElement('style');
        style.id = 'api-spin-style';
        style.textContent = '@keyframes api-spin{to{transform:rotate(360deg)}}';
        document.head.appendChild(style);
    }

    // ── Core fetch wrapper ───────────────────────────────────────

    /**
     * GET request returning parsed JSON.
     * @param {string} url
     * @param {object} [params] — query params object
     * @returns {Promise<object>}
     */
    function get(url, params) {
        var fullUrl = url;
        if (params) {
            var qs = Object.keys(params)
                .filter(function (k) { return params[k] !== null && params[k] !== undefined && params[k] !== ''; })
                .map(function (k) { return encodeURIComponent(k) + '=' + encodeURIComponent(params[k]); })
                .join('&');
            if (qs) fullUrl += (url.indexOf('?') >= 0 ? '&' : '?') + qs;
        }
        return fetch(fullUrl, {
            method: 'GET',
            headers: { 'X-Requested-With': 'XMLHttpRequest', 'Accept': 'application/json' },
            credentials: 'same-origin'
        }).then(_handleResponse);
    }

    /**
     * POST request with FormData or plain object body.
     * @param {string} url
     * @param {FormData|object} data
     * @returns {Promise<object>}
     */
    function post(url, data) {
        var body;
        var headers = { 'X-Requested-With': 'XMLHttpRequest', 'Accept': 'application/json' };
        if (data instanceof FormData) {
            body = data;
        } else {
            body = new URLSearchParams(data).toString();
            headers['Content-Type'] = 'application/x-www-form-urlencoded';
        }
        return fetch(url, {
            method: 'POST',
            headers: headers,
            body: body,
            credentials: 'same-origin'
        }).then(_handleResponse);
    }

    function _handleResponse(res) {
        if (res.status === 401 || res.status === 403) {
            toast('Phiên đăng nhập hết hạn. Đang chuyển hướng...', 'warn', 2500);
            setTimeout(function () { window.location.href = '/login'; }, 2500);
            return Promise.reject(new Error('Unauthorized'));
        }
        return res.json().then(function (json) {
            if (!res.ok) {
                var msg = (json && json.message) ? json.message : ('Lỗi ' + res.status);
                return Promise.reject(new Error(msg));
            }
            return json;
        }).catch(function (err) {
            if (err instanceof SyntaxError) return Promise.reject(new Error('Phản hồi không hợp lệ từ máy chủ'));
            return Promise.reject(err);
        });
    }

    // ── Public API ───────────────────────────────────────────────
    global.api = { get: get, post: post, toast: toast, showSpinner: showSpinner, hideSpinner: hideSpinner };

})(window);
