package com.formation.taskops.repository;

import com.formation.taskops.model.Task;
import com.formation.taskops.model.TaskStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Repository Spring Data JPA pour l'entite Task.
 * Les methodes de base (findAll, findById, save, deleteById, existsById...)
 * sont fournies automatiquement par JpaRepository.
 * findByStatus est derivee automatiquement du nom de la methode par Spring Data,
 * a partir du champ "status" de l'entite Task.
 */
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByStatus(TaskStatus status);
}
