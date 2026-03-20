package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        String loginServletURI = httpRequest.getContextPath() + "/login";
        String registerURI = httpRequest.getContextPath() + "/register.jsp";
        String registerServletURI = httpRequest.getContextPath() + "/register";
        String indexURI = httpRequest.getContextPath() + "/index.jsp";
        String rootURI = httpRequest.getContextPath() + "/";
        
        String requestURI = httpRequest.getRequestURI();

        boolean isStaticResource = requestURI.startsWith(httpRequest.getContextPath() + "/assets") ||
                                   requestURI.startsWith(httpRequest.getContextPath() + "/css") ||
                                   requestURI.startsWith(httpRequest.getContextPath() + "/js") ||
                                   requestURI.startsWith(httpRequest.getContextPath() + "/images");

        boolean isPublicOrLoginRequest = requestURI.equals(loginURI) || 
                                         requestURI.equals(loginServletURI) ||
                                         requestURI.equals(registerURI) ||
                                         requestURI.equals(registerServletURI) ||
                                         requestURI.equals(indexURI) ||
                                         requestURI.equals(rootURI);

        boolean isLoggedIn = session != null && session.getAttribute("account") != null;

        if (isLoggedIn || isPublicOrLoginRequest || isStaticResource) {
            // Cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập mà truy cập trang bảo vệ như booking, contracts... thì đẩy về login
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
