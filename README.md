# TD-Stockage-de-matrices-en-C

INSA Centre-Val de Loire
Spécialité : Sciences et Technologies Informatiques
Module : Programmation en langage C


## 1. Présentation du travail

Ce travail pratique porte sur la gestion et la manipulation des matrices en langage C.

L'objectif principal est de développer plusieurs fonctions permettant de créer, stocker, lire et manipuler des matrices en utilisant l'allocation dynamique de la mémoire.

Le travail est réalisé en binôme. Le développement est suivi à l'aide de Git et GitHub afin de faciliter la collaboration et de conserver l'historique des modifications.

## 2. Objectifs du TD

Ce travail pratique vise à mettre en application les notions de programmation en langage C, notamment la gestion de la mémoire et la manipulation des structures de données.

Les principaux objectifs sont les suivants :

- Comprendre la représentation d'une matrice en langage C.
- Utiliser l'allocation dynamique pour réserver la mémoire nécessaire.
- Gérer correctement les erreurs d'allocation.
- Lire, écrire et manipuler les matrices.
- Développer des fonctions fiables et réutilisables.
- Vérifier le bon fonctionnement du programme à l'aide de tests.
- Éviter les fuites mémoire grâce à une gestion rigoureuse des ressources.

## 3. Environnement de développement

La réalisation de ce TD s'appuie sur plusieurs outils :

- **Langage C :** développement des fonctions de gestion et de manipulation des matrices.
- **GCC :** compilation du programme avec les options de vérification.
- **Visual Studio Code :** édition et organisation du code source.
- **Git :** gestion des versions et suivi des modifications.
- **GitHub :** hébergement du dépôt et collaboration en binôme.
- **Valgrind :** détection des éventuelles fuites mémoire.

Les tests sont exécutés progressivement afin de vérifier le bon fonctionnement des fonctions développées.

## 4. Réalisation, exercice par exercice

### 4.1. Exercice 1 — Allocation et destruction des matrices

#### Objectif de l'exercice

L'objectif de cet exercice est de compléter les fonctions permettant de vérifier la validité d'une matrice, de l'allouer dynamiquement et de la détruire correctement.

#### 4.1.1. Code ajouté — Fichier `matrice.c`

**Étape 1.a — Ajout des messages d'erreur**

```c
case MAT_ERR_DIMENSIONS:  return "dimensions incompatibles";
case MAT_ERR_DEPASSEMENT: return "dépassement de capacité";
```

**Étape 1.b — Vérification de la validité d'une matrice**

```c
return m != NULL
    && m->coef != NULL
    && m->nb_lignes >= 1 && m->nb_lignes <= MAT_DIM_MAX
    && m->nb_colonnes >= 1 && m->nb_colonnes <= MAT_DIM_MAX;
```

#### 4.1.2. Code ajouté — Fichier `matrice_alloc.c`

**Étape 1.c — Vérification des dimensions**

```c
if (nb_lignes < 1 || nb_lignes > MAT_DIM_MAX ||
    nb_colonnes < 1 || nb_colonnes > MAT_DIM_MAX) {
    return MAT_ERR_ARGUMENT;
}
```

**Étape 1.d — Allocation des lignes**

```c
for (int i = 0; i < nb_lignes; i++) {
    coef[i] = mat_calloc((size_t)nb_colonnes, sizeof *coef[i]);
    if (coef[i] == NULL) {
        for (int k = i - 1; k >= 0; k--) {
            free(coef[k]);
        }
        free(coef);
        return MAT_ERR_ALLOCATION;
    }
}
```

**Étape 1.e — Initialisation de la matrice**

```c
res->coef = coef;
res->nb_lignes = nb_lignes;
res->nb_colonnes = nb_colonnes;
return MAT_OK;
```

**Étape 1.f — Libération de la mémoire**

```c
if (m->coef != NULL) {
    for (int i = 0; i < m->nb_lignes; i++) {
        free(m->coef[i]);
    }
    free(m->coef);
}
```

#### 4.1.3. Questions de réflexion

- **Q3.1 — Pourquoi `mat_detruire` prend-elle un pointeur vers la matrice ?**

  La fonction prend un pointeur pour pouvoir modifier directement la matrice d'origine. Elle libère la mémoire et remet la structure dans un état vide. Avec un passage par valeur, seule une copie locale serait modifiée.

- **Q3.2 — Combien d'appels à `calloc` et à `free` sont nécessaires pour une matrice de n lignes et p colonnes ?**

  Il faut `n + 1` appels à `calloc` : un pour le tableau de pointeurs et un pour chaque ligne. Pour détruire une matrice entièrement allouée, il faut également `n + 1` appels à `free`.

  Si une allocation échoue, il faut libérer toutes les allocations déjà réalisées.

- **Q3.3 — Pourquoi peut-on appeler deux fois `mat_detruire` sur la même matrice, mais pas sur une copie superficielle ?**

  Après le premier appel, la matrice est remise à l'état vide. Le deuxième appel ne provoque donc pas de double libération. En revanche, une copie superficielle partage les mêmes pointeurs. Détruire les deux matrices peut provoquer une double libération de mémoire.

- **Q3.4 — Pourquoi initialiser `*res` avec `MATRICE_VIDE` avant de commencer l'allocation ?**

  L'instruction `*res = MATRICE_VIDE;` permet d'initialiser la matrice résultat dans un état sûr. Ainsi, si les dimensions sont invalides ou si une allocation échoue, la matrice ne contient pas de pointeurs non initialisés.

#### 4.1.4. Tests et validation

Les tests de l'exercice 1 ont été exécutés afin de vérifier le bon fonctionnement des fonctions complétées.

**Résultat obtenu :**

```text
Bilan : 16 / 16
```

#### 4.1.5. Vérification de la mémoire avec Valgrind

La commande utilisée :

```bash
valgrind --leak-check=full ./test_ex1
```

**Résultat obtenu :**

### test_ex1

```text
==2498== HEAP SUMMARY:
==2498==     in use at exit: 0 bytes in 0 blocks
==2498==   total heap usage: 11 allocs, 11 frees, 1,228 bytes allocated
==2498==
==2498== All heap blocks were freed -- no leaks are possible
==2498==
==2498== For lists of detected and suppressed errors, rerun with: -s
==2498== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
![valgrind test_ex1](captures_valgrind/test_ex1.png)