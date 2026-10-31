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



### 4.2. Exercice 2 — Entrées-sorties
#### 4.2.2. Objectif de l'exercice
L'objectif de cet exercice est de compléter les fonctions permettant d'afficher une matrice, de l'écrire dans un fichier texte au format canonique, puis de la relire en détectant toute donnée invalide
#### 4.2.2. Code ajouté
**Étape 2.a — Affichage des coefficients**

```c
for (int i = 0; i < m->nb_lignes; i++) {
    for (int j = 0; j < m->nb_colonnes; j++)
        printf(" %8d", m->coef[i][j]);
    putchar('\n');
}
```

**Étape 2.b — Écriture des coefficients dans le fichier**

```c
for (int i = 0; i < m->nb_lignes; i++) {
    for (int j = 0; j < m->nb_colonnes; j++) {
        if (fprintf(f, j == 0 ? "%d" : " %d", m->coef[i][j]) < 0)
            return MAT_ERR_ECRITURE;
    }
    if (fputc('\n', f) == EOF)
        return MAT_ERR_ECRITURE;
}
```

**Étape 2.c — Vérification des dimensions lues**

```c
if (nb_lignes < 1 || nb_lignes > MAT_DIM_MAX)
    return MAT_ERR_FORMAT;
if (nb_colonnes < 1 || nb_colonnes > MAT_DIM_MAX)
    return MAT_ERR_FORMAT;
```

**Étape 2.d — Allocation d'une matrice locale**

```c
Matrice tmp;
err = mat_allouer(&tmp, nb_lignes, nb_colonnes);
if (err != MAT_OK)
    return err;
```

**Étape 2.e — Lecture des coefficients**

```c
for (int i = 0; i < nb_lignes; i++) {
    for (int j = 0; j < nb_colonnes; j++) {
        err = lire_entier(f, &tmp.coef[i][j]);
        if (err != MAT_OK) {
            mat_detruire(&tmp);
            return err;
        }
    }
}
```

**Étape 2.f — Transfert du résultat**

```c
*res = tmp;
return MAT_OK;
```

#### 4.2.3. Questions de réflexion
- **Q4.1 — Pourquoi `mat_lire` remplit-elle d'abord une matrice locale avant de l'affecter à `*res` ?**
 Une erreur peut survenir au milieu de la lecture (coefficient manquant, donnée non numérique, fichier tronqué). Si on remplissait `*res` directement, l'appelant recevrait une matrice à moitié remplie, ce qui est contraire à la règle R3. En remplissant d'abord la matrice locale `tmp`, on peut en cas d'erreur la détruire avec `mat_detruire(&tmp)` : `*res` reste alors égal à `MATRICE_VIDE`, puisqu'il a été mis à vide au début de la fonction. Le transfert `*res = tmp;` n'a lieu qu'à la toute fin, quand tout a réussi. Les tests « coefficient manquant » et « donnée non numérique » renvoient bien `MAT_ERR_FORMAT`, et valgrind ne signale aucune fuite.

- **Q4.2 — La lecture vérifie-t-elle que chaque ligne de la matrice est sur sa propre ligne de texte ? Est-ce gênant ? Justifiez le principe « tolérant en lecture, strict en écriture ».**
 Non. `fscanf` ignore les espaces et les sauts de ligne : le fichier est lu comme une simple suite de nombres. Par exemple, une matrice 2 × 3 écrite entièrement sur une seule ligne est acceptée. Ce n'est pas gênant, car les dimensions lues au début indiquent exactement combien de nombres il faut lire.

  Ce principe se justifie ainsi :
  - **Tolérant en lecture** : un fichier peut être écrit ou modifié à la main, avec des espaces, des tabulations ou des lignes vides en trop. Les refuser n'apporterait rien, car la mise en page ne change pas la matrice. On reste en revanche strict sur ce qui compte : dimensions valides, nombre exact de coefficients, entiers représentables par un `int`.
  - **Strict en écriture** : le programme produit toujours exactement le même format. Les fichiers sont donc prévisibles, faciles à comparer (le test `(2.b)` vérifie le contenu exact) et lisibles par n'importe quel autre programme.

- **Q4.3 — Après l'appel `mat_lire(f, &m)`, le flux `f` est positionné après le dernier coefficient. Comment exploiter cette propriété pour stocker deux matrices dans un même fichier ?**
 Il suffit d'écrire les deux matrices l'une après l'autre dans le même fichier, en appelant deux fois `mat_ecrire` sur le même flux. Pour les relire, on ouvre le fichier une seule fois avec `fopen`, on appelle `mat_lire(f, &a)` puis `mat_lire(f, &b)`, et on ferme avec `fclose`. Le second appel reprend exactement là où le premier s'est arrêté, c'est-à-dire sur les dimensions de la deuxième matrice. Cela fonctionne parce que `mat_lire` et `mat_ecrire` ne ferment jamais le flux.

 - **Q4.4 — Pourquoi `mat_ecrire` appelle-t-elle `fflush` avant de renvoyer `MAT_OK` ? Cela dispense-t-il l'appelant de tester `fclose` ?**
 `fprintf` n'écrit pas directement sur le disque : les données passent par un tampon en mémoire, et une erreur (disque plein, par exemple) peut n'apparaître qu'au moment où ce tampon est vidé. `fflush` force cette écriture tout de suite, ce qui permet à `mat_ecrire` de détecter l'erreur et de renvoyer `MAT_ERR_ECRITURE` au lieu d'un faux `MAT_OK`.

  Cela ne dispense pas l'appelant de tester `fclose`. La fermeture peut elle aussi échouer, par exemple si d'autres données ont été écrites après l'appel à `mat_ecrire`, ou si le système ne parvient à terminer l'écriture qu'au moment de la fermeture. C'est pour cela que la fonction `sauvegarder` de `main.c` teste le résultat de `fclose`.

  #### 4.2.3. Tests et validation

Les tests de l'exercice 2 ont été exécutés sous Linux (WSL) afin de vérifier le bon fonctionnement des fonctions complétées.

**Résultat obtenu :**

```text
Bilan : 14 / 14
```

#### 4.2.4. Vérification de la mémoire avec Valgrind

La commande utilisée :

```bash
valgrind --leak-check=full ./test_ex2
```

**Résultat obtenu :**

### test_ex2

```text
==4054== HEAP SUMMARY:
==4054==     in use at exit: 0 bytes in 0 blocks
==4054==   total heap usage: 51 allocs, 51 frees, 60,728 bytes allocated
==4054==
==4054== All heap blocks were freed -- no leaks are possible
==4054==
==4054== For lists of detected and suppressed errors, rerun with: -s
==4054== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
![valgrind test_ex2](captures_valgrind/test_ex2.png)