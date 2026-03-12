package service;

import java.util.List;

/**
 * Generic Base Service interface for CRUD operations.
 * @param <T> Entity type
 * @param <K> ID type
 */
public interface IService<T, K> {
    List<T> findAll();
    T findById(K id);
    void save(T item);
    void delete(K id);
}
