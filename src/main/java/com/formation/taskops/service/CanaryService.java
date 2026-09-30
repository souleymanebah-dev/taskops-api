package com.formation.taskops.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.concurrent.ThreadLocalRandom;

@Service
public class CanaryService {

    private final int pourcentage;

    public CanaryService(@Value("${taskops.canary.pourcentage:0}") int pourcentage) {
        this.pourcentage = Math.clamp(pourcentage, 0, 100);
    }

    public boolean utiliserNouvelleVersion() {
        if (pourcentage <= 0) {
            return false;
        }
        if (pourcentage >= 100) {
            return true;
        }
        return ThreadLocalRandom.current().nextInt(100) < pourcentage;
    }

    public int getPourcentage() {
        return pourcentage;
    }
}
