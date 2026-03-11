package config;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

/**
 * JAX-RS Configuration.
 * Base path for all REST endpoints is /api.
 */
@ApplicationPath("/api")
public class RestApplication extends Application {
    
}
