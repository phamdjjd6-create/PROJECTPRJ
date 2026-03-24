package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Locale;

@WebFilter("/*")
public class LocaleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        String lang = req.getParameter("lang");
        
        if (lang != null && !lang.isEmpty()) {
            Locale locale = new Locale(lang);
            HttpSession session = req.getSession();
            session.setAttribute("jakarta.servlet.jsp.jstl.fmt.locale", locale);
            session.setAttribute("currentLang", lang);
        }
        
        chain.doFilter(request, response);
    }
}
