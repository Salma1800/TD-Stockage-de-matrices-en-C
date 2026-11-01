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

## 4.1. Exercice 1 — Allocation et destruction des matrices

### Objectif de l'exercice
  L'objectif de cet exercice est de compléter les fonctions permettant de vérifier la validité d'une matrice, de l'allouer dynamiquement et de la détruire correctement. Cet exercice permet notamment de comprendre la gestion de la mémoire dynamique en langage C, l'utilisation des pointeurs et la gestion des erreurs d'allocation. Il faut également garantir que les matrices restent dans un état sûr lorsqu'une opération échoue, afin d'éviter les fuites mémoire et les erreurs liées à l'utilisation de pointeurs invalides.

### 4.1.1. Code ajouté — Fichier `matrice.c`
**Étape 1.a — Ajout des messages d'erreur**
```c
case MAT_ERR_DIMENSIONS:  return "dimensions incompatibles";
case MAT_ERR_DEPASSEMENT: return "dépassement de capacité";
```

Ces deux instructions permettent d'associer un message explicite à deux types d'erreurs pouvant être rencontrées lors des opérations sur les matrices. `MAT_ERR_DIMENSIONS` indique que les dimensions des matrices ne permettent pas d'effectuer l'opération demandée. `MAT_ERR_DEPASSEMENT` signale qu'un résultat dépasse la capacité de représentation du type entier utilisé. Ces messages facilitent la compréhension des erreurs lors de l'exécution et permettent d'obtenir des informations plus précises au lieu d'afficher uniquement un code numérique.

**Étape 1.b — Vérification de la validité d'une matrice**
```c
return m != NULL
    && m->coef != NULL
    && m->nb_lignes >= 1 && m->nb_lignes <= MAT_DIM_MAX
    && m->nb_colonnes >= 1 && m->nb_colonnes <= MAT_DIM_MAX;
```

Cette condition permet de vérifier qu'une matrice respecte les règles de validité définies dans le programme. Tout d'abord, `m != NULL` vérifie que le pointeur vers la structure existe. Ensuite, `m->coef != NULL` garantit que le tableau contenant les coefficients a bien été alloué. Les deux dernières conditions vérifient que le nombre de lignes et de colonnes est compris entre 1 et `MAT_DIM_MAX`. L'utilisation de l'opérateur `&&` impose que toutes les conditions soient vraies pour considérer la matrice comme valide. Cela évite notamment de manipuler une matrice vide ou dont les dimensions sont incorrectes.

### 4.1.2. Code ajouté — Fichier `matrice_alloc.c`
**Étape 1.c — Vérification des dimensions**
```c
if (nb_lignes < 1 || nb_lignes > MAT_DIM_MAX ||
    nb_colonnes < 1 || nb_colonnes > MAT_DIM_MAX) {
    return MAT_ERR_ARGUMENT;
}
```

Cette vérification est effectuée avant toute allocation mémoire afin de s'assurer que les dimensions demandées sont autorisées. Une matrice doit posséder au moins une ligne et une colonne, et ses dimensions ne doivent pas dépasser la limite définie par `MAT_DIM_MAX`. L'opérateur `||` permet de détecter si au moins une des quatre conditions est vérifiée. Si les dimensions sont incorrectes, la fonction renvoie `MAT_ERR_ARGUMENT` sans effectuer d'allocation. Cette vérification évite donc de réserver inutilement de la mémoire pour une matrice qui ne respecte pas les contraintes du programme.

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

Cette boucle permet d'allouer séparément chaque ligne de la matrice. La fonction `mat_calloc` réserve la mémoire nécessaire pour stocker `nb_colonnes` entiers et initialise les zones allouées à zéro. Le résultat de chaque allocation est enregistré dans `coef[i]`. Si une allocation échoue, le pointeur obtenu vaut `NULL` : il faut alors libérer toutes les lignes précédemment allouées, puis libérer le tableau de pointeurs `coef`. La fonction renvoie ensuite `MAT_ERR_ALLOCATION`. Cette gestion des erreurs est essentielle pour éviter les fuites mémoire lorsqu'une allocation échoue au milieu de la création de la matrice.

**Étape 1.e — Initialisation de la matrice**
```c
res->coef = coef;
res->nb_lignes = nb_lignes;
res->nb_colonnes = nb_colonnes;

return MAT_OK;
```

Une fois toutes les allocations réussies, les informations de la matrice sont enregistrées dans la structure pointée par `res`. Le champ `coef` reçoit l'adresse du tableau de pointeurs contenant les différentes lignes. Les champs `nb_lignes` et `nb_colonnes` permettent ensuite de connaître les dimensions de la matrice. Cette initialisation n'est effectuée qu'après la réussite de toutes les allocations, ce qui évite de présenter comme valide une matrice qui n'aurait été que partiellement construite. Enfin, `MAT_OK` indique que l'allocation s'est terminée correctement.

**Étape 1.f — Libération de la mémoire**
```c
if (m->coef != NULL) {
    for (int i = 0; i < m->nb_lignes; i++) {
        free(m->coef[i]);
    }

    free(m->coef);
}
```

Cette partie permet de libérer correctement toute la mémoire utilisée par une matrice. Il faut commencer par parcourir les lignes et libérer chacune d'elles avec `free(m->coef[i])`. Ensuite, le tableau principal contenant les pointeurs vers ces lignes est libéré avec `free(m->coef)`. Il est important de respecter cet ordre, car libérer le tableau principal avant les lignes ferait perdre les adresses nécessaires pour les libérer. La vérification `m->coef != NULL` évite également de tenter de libérer un tableau qui n'existe pas. Après cette opération, la fonction fournie remet la structure dans l'état `MATRICE_VIDE`, ce qui permet notamment de sécuriser un nouvel appel à `mat_detruire`.

### 4.1.3. Questions de réflexion
- **Q3.1 — Pourquoi `mat_detruire` prend-elle un pointeur vers la matrice ?**
 La fonction `mat_detruire` prend un pointeur vers la matrice afin de pouvoir modifier directement la structure d'origine. En effet, elle ne se contente pas de libérer la mémoire occupée par les coefficients : elle doit également remettre la structure dans un état vide avec `*m = MATRICE_VIDE`. Si la matrice était passée par valeur, seule une copie locale de la structure serait modifiée, tandis que la structure d'origine conserverait ses anciens pointeurs. Cela pourrait entraîner l'utilisation de pointeurs invalides après la libération de la mémoire. Le passage par adresse permet donc de libérer les ressources et de mettre à jour la matrice réellement utilisée par le programme.

- **Q3.2 — Combien d'appels à `calloc` et à `free` sont nécessaires pour une matrice de n lignes et p colonnes ?**
 Pour une matrice de n lignes et p colonnes, il faut effectuer n + 1 allocations : un premier appel pour réserver le tableau de n pointeurs, puis n appels supplémentaires pour allouer individuellement les lignes contenant chacune p entiers. La destruction d'une matrice entièrement allouée nécessite également n + 1 appels à `free` : un pour chaque ligne et un pour le tableau principal. Le nombre de colonnes p influence la quantité de mémoire réservée pour chaque ligne, mais pas le nombre d'allocations. Si une allocation échoue pendant la création, seules les allocations déjà réussies doivent être libérées. Cette gestion garantit qu'aucune zone mémoire ne reste inutilisée sans possibilité de la libérer.

- **Q3.3 — Pourquoi peut-on appeler deux fois `mat_detruire` sur la même matrice, mais pas sur une copie superficielle ?**
 Après un premier appel à `mat_detruire`, la fonction libère les lignes, puis le tableau de pointeurs, et remet la structure à l'état `MATRICE_VIDE`. Lors d'un deuxième appel sur cette même structure, le champ `coef` vaut `NULL` : aucune nouvelle libération n'est donc effectuée. En revanche, une copie superficielle d'une matrice ne copie pas les données elles-mêmes, mais uniquement les valeurs des champs de la structure, notamment les adresses des pointeurs. Les deux structures partagent alors les mêmes zones mémoire. Si chacune est détruite, le même espace mémoire risque d'être libéré deux fois, ce qui provoque une double libération et un comportement indéfini. Il faut donc respecter une seule responsabilité de libération pour chaque allocation.

- **Q3.4 — Pourquoi initialiser `*res` avec `MATRICE_VIDE` avant de commencer l'allocation ?**
 L'instruction `*res = MATRICE_VIDE` permet de placer immédiatement la matrice résultat dans un état connu et sûr avant de commencer les allocations. Ainsi, si les dimensions sont invalides ou si une allocation échoue, la structure ne contient pas d'anciennes adresses ou de pointeurs non initialisés. Cette initialisation facilite également la gestion des erreurs, car l'appelant sait que le résultat reste vide lorsque la fonction échoue. Dans notre implémentation, les lignes ne sont enregistrées dans `res` qu'après la réussite de toutes les allocations. Les allocations partielles sont directement libérées avant le retour de la fonction. Cette organisation garantit donc une gestion cohérente de la mémoire et évite de laisser une matrice dans un état partiellement construit.

### 4.1.4. Tests et validation
Les tests de l'exercice 1 ont été exécutés afin de vérifier le bon fonctionnement des fonctions complétées. Ils permettent notamment de contrôler la validité des matrices, le respect des dimensions autorisées, le bon déroulement des allocations et la libération correcte de la mémoire. 

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
(voir 5. Vérification mémoire)


### 4.2. Exercice 2 — Entrées-sorties
#### Objectif de l'exercice
L'objectif de cet exercice est de compléter les fonctions permettant d'afficher une matrice, de l'écrire dans un fichier texte au format canonique, puis de la relire en détectant toute donnée invalide
#### 4.2.1. Code ajouté — Fichier `matrice_io.c`

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
(voir 5. Vérification mémoire)


## 4.3. Exercice 3 — Addition et multiplication de matrices
### 4.3.1. Objectif de l'exercice
L'objectif de cet exercice est de compléter le fichier `matrice_calcul.c` afin de permettre l'addition et la multiplication de deux matrices. Ces opérations nécessitent de vérifier la compatibilité des dimensions avant d'effectuer les calculs. Il faut également garantir que les matrices d'entrée ne sont jamais modifiées et que le résultat possède sa propre allocation mémoire. Enfin, les calculs doivent être réalisés en évitant les dépassements de capacité des entiers et en assurant une gestion correcte de la mémoire en cas d'erreur.

### 4.3.2. Code ajouté — Fichier `matrice_calcul.c`

**Étape 3.a — Vérification des dimensions pour l'addition**

Avant d'effectuer l'addition, il faut vérifier que les deux matrices possèdent le même nombre de lignes et de colonnes. Si l'une de ces conditions n'est pas respectée, la fonction renvoie `MAT_ERR_DIMENSIONS`.

```c
if (a->nb_lignes != b->nb_lignes ||
    a->nb_colonnes != b->nb_colonnes) {
    return MAT_ERR_DIMENSIONS;
}
```

**Étape 3.b — Allocation de la matrice résultat**

Une nouvelle matrice `r` est créée avec les mêmes dimensions que la matrice `a`. La fonction `mat_allouer` réserve dynamiquement la mémoire nécessaire. Si l'allocation échoue, l'erreur est immédiatement renvoyée.

```c
Matrice r = MATRICE_VIDE;
err = mat_allouer(&r, a->nb_lignes, a->nb_colonnes);
if (err != MAT_OK)
    return err;
```

**Étape 3.c — Calcul de la somme des coefficients**

Chaque coefficient du résultat est obtenu en additionnant les coefficients correspondants des deux matrices. Le type `long long` est utilisé pour effectuer le calcul dans un type plus grand avant de vérifier que le résultat peut être stocké dans un `int`.

```c
long long s = (long long)a->coef[i][j] + b->coef[i][j];
```

**Étape 3.d — Transfert du résultat**

Une fois tous les coefficients calculés et vérifiés, la structure `r` est transférée dans `res`. Le résultat conserve ainsi la mémoire qui vient d'être allouée. Il ne faut pas détruire `r` après ce transfert, car cette mémoire appartient désormais à `res`.

```c
*res = r;
return MAT_OK;
```

**Étape 3.e — Vérification des dimensions pour la multiplication**

Pour multiplier deux matrices, le nombre de colonnes de la première matrice doit être égal au nombre de lignes de la deuxième. Si cette condition n'est pas respectée, le produit matriciel n'est pas défini et la fonction renvoie `MAT_ERR_DIMENSIONS`.

```c
if (a->nb_colonnes != b->nb_lignes)
    return MAT_ERR_DIMENSIONS;
```

**Étape 3.f — Allocation de la matrice résultat**

La matrice résultat doit posséder le nombre de lignes de `a` et le nombre de colonnes de `b`. La mémoire est réservée avec `mat_allouer`. En cas d'échec, la fonction renvoie directement l'erreur, sans laisser de mémoire partiellement allouée.

```c
Matrice r = MATRICE_VIDE;
err = mat_allouer(&r, a->nb_lignes, b->nb_colonnes);
if (err != MAT_OK)
    return err;
```

**Étape 3.g — Calcul du produit des matrices et détection des dépassements**

Pour calculer chaque coefficient du résultat, on multiplie les coefficients de la ligne `i` de la première matrice par ceux de la colonne `j` de la deuxième matrice, puis on additionne les produits obtenus. Le calcul intermédiaire est réalisé en `long long`. Avant chaque addition, une vérification permet de détecter un éventuel dépassement de capacité de ce type. En cas d'erreur, la matrice résultat est détruite afin d'éviter une fuite mémoire.

```c
for (int k = 0; k < a->nb_colonnes; k++) {
    long long p = (long long)a->coef[i][k] * b->coef[k][j];

    if ((p > 0 && s > LLONG_MAX - p)
        || (p < 0 && s < LLONG_MIN - p)) {
        mat_detruire(&r);
        return MAT_ERR_DEPASSEMENT;
    }

    s += p;
}
```

**Étape 3.h — Transfert du résultat**

Après le calcul de tous les coefficients et les vérifications nécessaires, la matrice obtenue est transférée vers `res`. La fonction renvoie `MAT_OK` pour indiquer que l'opération s'est terminée correctement.

```c
*res = r;
return MAT_OK;
```

### 4.3.3. Questions de réflexion

- **Q5.1 — Le paramètre `const Matrice *a` empêche-t-il d'écrire `a->coef[0][0] = 7;` ? Que protège exactement ce `const` ? Que faudrait-il changer pour que le compilateur refuse cette affectation ?**
 Non, le paramètre `const Matrice *a` ne suffit pas à empêcher la modification des coefficients. Le mot-clé `const` protège les champs de la structure accessibles à travers le pointeur `a`, mais il ne rend pas automatiquement constantes les données pointées par `coef`. Comme `coef` est un pointeur vers des pointeurs d'entiers, l'expression `a->coef[0][0]` reste modifiable avec la représentation actuelle. Pour interdire cette modification au compilateur, il faudrait également utiliser une représentation en lecture seule des coefficients, par exemple avec des pointeurs vers des entiers constants (`const int`). Une autre solution consiste à utiliser un type distinct représentant une vue constante de la matrice. Cela permettrait de séparer clairement les fonctions qui peuvent modifier les coefficients de celles qui doivent uniquement les consulter.

- **Q5.2 — Pourquoi refuse-t-on l'appel `mat_additionner(&a, &b, &a)` alors que mathématiquement l'opération `a ← a + b` a un sens ? Que se passerait-il avec notre implémentation si on l'acceptait ?**
 Mathématiquement, il est tout à fait possible de remplacer une matrice par la somme de cette matrice et d'une autre. Cependant, notre implémentation ne permet pas cette opération car le paramètre `res` doit être différent des deux matrices d'entrée. Cette règle est vérifiée par la fonction fournie `verifier_parametres`, qui renvoie `MAT_ERR_ARGUMENT` si `res == a` ou `res == b`. En effet, cette fonction initialise d'abord le résultat avec `*res = MATRICE_VIDE`. Si `res` désignait directement `a`, cette instruction écraserait les informations de la matrice d'entrée, notamment son pointeur vers la mémoire allouée. Les données seraient alors perdues et une fuite mémoire pourrait se produire. Le refus de cet appel garantit donc la protection des matrices d'entrée et le respect des règles de propriété de la mémoire définies dans le module.

- **Q5.3 — Combien de multiplications d'entiers effectue `mat_multiplier` pour des matrices de dimensions n × p et p × q ? Combien pour deux matrices 1000 × 1000 ?**
 Pour multiplier une matrice de dimensions n × p par une matrice de dimensions p × q, le résultat possède n lignes et q colonnes. Chaque coefficient du résultat est calculé à partir de p multiplications, correspondant aux produits des coefficients d'une ligne de la première matrice avec ceux d'une colonne de la deuxième. Comme le résultat contient n × q coefficients, le nombre total de multiplications est donc n × p × q. Pour deux matrices carrées de dimensions 1000 × 1000, chaque coefficient nécessite 1000 multiplications et le résultat contient 1 000 000 de coefficients. Le nombre total est donc de 1000 × 1000 × 1000, soit **1 000 000 000 de multiplications**. Cette complexité montre que le nombre d'opérations augmente rapidement avec la taille des matrices.

- **Q5.4 — Pourquoi ne suffit-il pas de calculer `int s = a + b;` puis de tester `s < a` pour détecter un dépassement ?**
 Cette méthode n'est pas fiable car le dépassement d'un entier signé en C entraîne un comportement indéfini. Cela signifie que le programme ne garantit pas le résultat de l'addition lorsque la valeur obtenue dépasse les limites du type `int`. La vérification effectuée après le calcul arrive donc trop tard : le dépassement a déjà pu se produire. De plus, le test `s < a` ne permet pas de détecter correctement tous les cas de dépassement, notamment lorsque les opérandes peuvent être négatifs. Dans notre implémentation, nous utilisons donc le type `long long` pour effectuer les calculs intermédiaires. Nous vérifions ensuite que le résultat appartient à l'intervalle `[INT_MIN, INT_MAX]` avec la fonction fournie `tient_dans_int`. Si cette condition n'est pas respectée, la fonction renvoie `MAT_ERR_DEPASSEMENT` et libère la mémoire du résultat avant de quitter.

### 4.3.4. Tests et validation
 Les tests de l'exercice 3 ont été exécutés afin de vérifier le bon fonctionnement des fonctions complétées. Ils permettent de contrôler les dimensions des matrices, l'exactitude des calculs, la détection des dépassements de capacité, la conservation des matrices d'entrée et la gestion des erreurs d'allocation.

**Résultat obtenu :**

```text
=== Exercice 3 : addition ===
[OK] (3.a) (2 x 3) + (3 x 2) : MAT_ERR_DIMENSIONS
[OK] (3.d) (2 x 3) + (2 x 3) : MAT_OK
[OK] (3.c) a + b est correct
[OK] a et b n’ont pas ete modifiees
[OK] (3.b) le resultat possede sa propre memoire
[OK] (3.c) INT_MAX + 1 : MAT_ERR_DEPASSEMENT
=== Exercice 3 : multiplication ===
[OK] (3.e) (2 x 3) x (2 x 3) : MAT_ERR_DIMENSIONS
[OK] (3.h) (2 x 3) x (3 x 2) : MAT_OK
[OK] (3.g) a x c = (58 64 / 139 154)
[OK] (3.f) (3 x 2) x (2 x 3) donne une matrice 3 x 3
[OK] a et c n’ont pas ete modifiees
[OK] (3.g) 2 x 10^10 depasse INT_MAX : MAT_ERR_DEPASSEMENT
=== Exercice 3 : cas particuliers ===
[OK] resultat = entree refuse, a reste intacte
[OK] (3.f) echec d’allocation : MAT_ERR_ALLOCATION, r vide

Bilan : 14 / 14 verifications reussies.
```

### 4.3.5. Vérification de la mémoire avec Valgrind



### 4.4. Exercice 4 — Démonstration complète
#### Objectif de l'exercice
L'objectif de cet exercice est d'assembler les quatre modules dans un programme de démonstration qui lit deux matrices depuis des fichiers, calcule leur somme ou leur produit, affiche et enregistre le résultat, et traite proprement chaque erreur en libérant toute la mémoire.

#### 4.4.1. Code ajouté — Fichier `main.c`

**Étape 4.a — Affichage des matrices A et B**

```c
mat_afficher("A", &a);
mat_afficher("B", &b);
```

**Étape 4.b — Calcul du résultat**

```c
MatErreur err = addition ? mat_additionner(&a, &b, &r)
                         : mat_multiplier(&a, &b, &r);
if (err != MAT_OK) {
    fprintf(stderr, "Erreur : calcul impossible : %s ",
            mat_message_erreur(err));
    fprintf(stderr, "(A : %d x %d, B : %d x %d)\n",
            a.nb_lignes, a.nb_colonnes, b.nb_lignes, b.nb_colonnes);
    goto nettoyage;
}
```

**Étape 4.c — Affichage du résultat**

```c
mat_afficher(addition ? "R = A + B" : "R = A x B", &r);
```

**Étape 4.d — Signalement du succès**

```c
printf("Résultat enregistré dans \"%s\".\n", argv[4]);
statut = EXIT_SUCCESS;
```

#### 4.4.3. Questions de réflexion: 
- **Q6.1 — Pourquoi le message d'erreur est-il affiché par `main.c` (ou ses fonctions `static`) et non par `mat_lire` ? Pensez à un programme graphique qui réutiliserait la bibliothèque.**
  La bibliothèque est faite pour être réutilisée par différents programmes, qui n'affichent pas tous leurs erreurs de la même manière. `mat_lire` se contente donc de renvoyer un code d'erreur, et c'est le programme appelant qui décide quoi en faire. Un programme graphique, par exemple, n'a pas de terminal : un message écrit sur `stderr` par `mat_lire` ne serait jamais vu par l'utilisateur, alors que le programme voudrait plutôt afficher une fenêtre d'erreur. De plus, `mat_lire` reçoit un flux déjà ouvert et ne connaît pas le nom du fichier. C'est `charger`, dans `main.c`, qui connaît le chemin et peut afficher un message précis grâce à `mat_message_erreur`.

- **Q6.2 — Pourquoi le résultat de `fclose` est-il testé dans `sauvegarder` mais pas dans `charger` ?**

  En écriture, les données passent par un tampon en mémoire et ne sont réellement écrites sur le disque qu'au moment où ce tampon est vidé, au plus tard lors du `fclose`. Si `fclose` échoue (disque plein, par exemple), le fichier peut être incomplet : il faut le signaler à l'utilisateur, sinon il croirait que l'enregistrement a réussi. En lecture, au contraire, quand on arrive au `fclose`, la matrice a déjà été entièrement lue et se trouve en mémoire. Un échec de la fermeture ne change rien au résultat : il n'y a aucune donnée à perdre, donc rien à signaler.

- **Q6.3 — Dans le scénario 8, le calcul a réussi mais l'enregistrement a échoué. Combien de matrices faut-il libérer ? Vérifiez que votre programme le fait.**

  Il faut libérer les trois matrices : A et B, qui ont été lues, et R, qui a été calculée. Toutes les trois possèdent de la mémoire au moment où l'enregistrement échoue. Dans notre programme, l'échec de `sauvegarder` provoque un `goto nettoyage`, et le nettoyage appelle `mat_detruire` sur `r`, `b` et `a`. Il n'y a rien à gérer au cas par cas : comme `mat_detruire` ne fait rien sur une matrice vide, le même nettoyage convient à tous les chemins d'erreur.

 #### 4.4.4. Tests et validation

Les tests de l'exercice 4 ont été exécutés sous Linux (WSL) afin de vérifier le bon fonctionnement des fonctions complétées.
**Résultat obtenu :**


#### 4.4.5. Vérification de la mémoire avec Valgrind

La commande utilisée :

```bash
valgrind --leak-check=full ./test_ex1
```

**Résultat obtenu :**
(voir 5. Vérification mémoire)

 ## 5. Vérification mémoire
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



 ## 6. Démonstration finale



 ## 7. Bilan et difficultés