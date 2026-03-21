/**
 * Drum Date Picker — scroll wheel style
 * Usage: new DrumDatePicker(inputEl, options)
 */
class DrumDatePicker {
    constructor(inputEl, options = {}) {
        this.input = inputEl;
        this.minDate = options.minDate || null;
        this.maxDate = options.maxDate || null;
        this.onChange = options.onChange || null;

        const today = new Date();
        let initDate = today;
        if (inputEl.value) {
            const p = inputEl.value.split('-');
            if (p.length === 3) initDate = new Date(+p[0], +p[1]-1, +p[2]);
        }

        this.selected = { d: initDate.getDate(), m: initDate.getMonth()+1, y: initDate.getFullYear() };
        this._build();
    }

    _build() {
        // Wrapper
        this.wrapper = document.createElement('div');
        this.wrapper.className = 'drum-dp-wrapper';

        // Display button
        this.display = document.createElement('div');
        this.display.className = 'drum-dp-display';
        this.display.innerHTML = `<span class="drum-dp-icon">📅</span><span class="drum-dp-text">${this._formatDisplay()}</span>`;
        this.display.addEventListener('click', () => this._toggle());

        // Popup
        this.popup = document.createElement('div');
        this.popup.className = 'drum-dp-popup';
        this.popup.innerHTML = `
            <div class="drum-dp-header">
                <span>NGÀY</span><span>THÁNG</span><span>NĂM</span>
            </div>
            <div class="drum-dp-drums">
                <div class="drum-dp-col" id="${this.input.id}_days"></div>
                <div class="drum-dp-col" id="${this.input.id}_months"></div>
                <div class="drum-dp-col" id="${this.input.id}_years"></div>
            </div>
            <div class="drum-dp-footer">
                <button class="drum-dp-cancel">Hủy</button>
                <button class="drum-dp-confirm">Xác nhận</button>
            </div>`;

        this.popup.querySelector('.drum-dp-cancel').addEventListener('click', () => this._close());
        this.popup.querySelector('.drum-dp-confirm').addEventListener('click', () => this._confirm());

        this.wrapper.appendChild(this.display);
        this.wrapper.appendChild(this.popup);
        this.input.parentNode.insertBefore(this.wrapper, this.input);
        this.wrapper.appendChild(this.input);
        this.input.style.display = 'none';

        this._renderDrums();

        // Close on outside click
        document.addEventListener('click', (e) => {
            if (!this.wrapper.contains(e.target)) this._close();
        });
    }

    _daysInMonth(m, y) { return new Date(y, m, 0).getDate(); }

    _renderDrums() {
        const { d, m, y } = this.selected;
        const maxDay = this._daysInMonth(m, y);

        const minY = this.minDate ? this.minDate.getFullYear() : 1950;
        const maxY = this.maxDate ? this.maxDate.getFullYear() : new Date().getFullYear() + 10;

        this._renderCol(`${this.input.id}_days`,   Array.from({length: maxDay}, (_,i) => i+1), d, 'day');
        this._renderCol(`${this.input.id}_months`, Array.from({length: 12},    (_,i) => i+1), m, 'month');
        this._renderCol(`${this.input.id}_years`,  Array.from({length: maxY - minY + 1}, (_,i) => minY+i), y, 'year');
    }

    _renderCol(id, items, selected, type) {
        const col = document.getElementById(id);
        col.innerHTML = '';
        const drum = document.createElement('div');
        drum.className = 'drum-dp-drum';

        items.forEach(val => {
            const item = document.createElement('div');
            item.className = 'drum-dp-item' + (val === selected ? ' active' : '');
            item.textContent = String(val).padStart(2, '0');
            item.dataset.val = val;
            item.addEventListener('click', () => {
                drum.querySelectorAll('.drum-dp-item').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
                this.selected[type === 'day' ? 'd' : type === 'month' ? 'm' : 'y'] = val;
                if (type === 'month' || type === 'year') this._rerenderDays();
                item.scrollIntoView({ block: 'center', behavior: 'smooth' });
            });
            drum.appendChild(item);
        });

        col.appendChild(drum);

        // Scroll to selected
        setTimeout(() => {
            const active = drum.querySelector('.active');
            if (active) active.scrollIntoView({ block: 'center' });
        }, 50);
    }

    _rerenderDays() {
        const { d, m, y } = this.selected;
        const maxDay = this._daysInMonth(m, y);
        const clampedDay = Math.min(d, maxDay);
        this.selected.d = clampedDay;
        this._renderCol(`${this.input.id}_days`, Array.from({length: maxDay}, (_,i) => i+1), clampedDay, 'day');
    }

    _formatDisplay() {
        const { d, m, y } = this.selected;
        return `${String(d).padStart(2,'0')}/${String(m).padStart(2,'0')}/${y}`;
    }

    _toggle() {
        this.popup.classList.toggle('open');
        if (this.popup.classList.contains('open')) {
            setTimeout(() => {
                ['days','months','years'].forEach(t => {
                    const active = document.querySelector(`#${this.input.id}_${t} .active`);
                    if (active) active.scrollIntoView({ block: 'center' });
                });
            }, 50);
        }
    }

    _close() { this.popup.classList.remove('open'); }

    _confirm() {
        const { d, m, y } = this.selected;
        const val = `${y}-${String(m).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
        this.input.value = val;
        this.display.querySelector('.drum-dp-text').textContent = this._formatDisplay();
        if (this.onChange) this.onChange(val);
        this._close();
    }
}
