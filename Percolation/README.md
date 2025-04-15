# Percolation

Author: Duoxiang Zhao

## INTRODUCTION

Percolation is a model to simulate the behavior of connected clusters in a random graph. Using an N-by-N grid of sites, each of which can be open or close independently. Fill site is defined as an open site whose neighbor 4 sites (up, down, left, right) are all open. If there is a path of open site from top to the bottom, we say the system percolates. Although the model can be implemented by union find structure, the critical value of p, `p*`, which refers to the site vacancy probability, has still no percise solution. If the value of opening site is greater than p\*, the system is likely to be open, otherwise, it is likely to be close. The task is to estimate `p*` by using Monte Carlo Method, and compute some statistics of `p*`.

## PERCOLATION.JAVA

### First Implementation

To implement the Percolation.java using the Union-find datatype, some preparations are needed. 

We need some fields, like the size of the grid, the status of the grid, a counter of open grid, and a `QuickUnion`type uf to be the Union-Find Set. We can reshape the 2D array (grid) to 1D array (Union-Find Set), and vice versa. Additionally, we also need a Virtual Top and a Virtual Bottom Node to be marked as begin and end. Therefore, a Union-Find Set whose index ranges from 0 (Top) to (N^2+1) (Bottom) is needed.

Then we can implement the rest. For the constructor, it costs approximately O(N^2). For other methods, each of them cost constant time, even for open() method. A new method 'connectToTop()' is defined, to probe whether a node is connected to top. It is useful. According to the task, the other methods can be implemented easily.

### About `@Deprecated`

In Java, the annotation `@Deprecated` is "one that programmers are discouraged from using." (Java 21, Oracle.com) Therefore, I change some logic in order to avoid using 'connected' method by using `find(p) == find(q)`.

### Second Implementation

After seeing some solutions, I find that my code has bugs. One is called 'Backwash', meaning that the last row sites that are open will be mistaken mark as connected to top if percolation occurs, which can increase the number of the open sites and has impact on the calculation of `p*`. Followed by the hint, I tried to introduce another Union-Find set, which is not connected to the bottom.

## PERCOLATIONTEST.JAVA

PercolationTest.java uses Monte Carlo Simulation Method. It will continuously open a random site until percolation occurs. Then, the mean and standard deviation as well as 95% Confidence Interval will be calculated. 

## DISCUSSION

### Compute the Statistics in PercolationStats.

Generally speaking, a higher N and a higher T can get a better performance of `p*`. Fro N = 200, T = 100, the mean value of p = 0.5915, 95% CI is [0.5893, 0.5936] (for reference). When N = 2000, T = 1000, the mean value of p is 0.5920, and 95% CI is [0.5913, 0.5927], which is very close to the prediction value p \approx 0.5931.

### Measure the Total Running Time, and Compare the Influence of Changing N and T.

The running time is approximately proportional to the square of the grid size, N^2, and is approximately proportional to the times of trials, T. When N = 100, T = 100, running time is 3.1450s, whereas N = 200, T = 200, running time rises to 6.0900s, approximately twice than previous. If setting N = 200, T = 100, running time is 67.1110s, much more higher than the first one.
Therefore, total running time is (in formula):

Running Time ~ T · N^4.

Since even if find is O(1), union(p ,q) is still O(N^2), for the traversal of the whole array.

### Give the Memory Usage in Bytes that a Percolation Object Uses to Model an N-by-N Percolation System.

> Percolation Object: 8 (Field) + 4 (Pointer) + 4 (Padding) = 16 bytes.
> 4 integer: 16 bytes.
> 3 Reference (boolean [][], uf, uf_back): 24 bytes
> boolean[][] 16N + N^2 (1D Array and boolean value)
> QuickFindUF:
> Percolation Object: 8 (Field) + 4 (Pointer) + 4 (Padding) = 16 bytes.
> Object: 16 bytes
> One int[]: 2* (4 * (N^2 + 2) + 24) = 8N^2 + 64 bytes.
> int count: 4 bytes
> Reference: 2 * 8 = 16 bytes
>
> Total: 16 + 16 + 24 + 16N + N^2 + 16 + 16 + 8N^2 + 64 + 4 + 16 = 9N^2 + 16N +172 ~ 9N^2.
>

### Answer Question 2 Again, Using the Weighted Quick-Union Datatype.

The running time is approximately proportional to the square of the grid size, N^2, and is approximately proportional to the times of trials, T. When N = 200, T = 100, running time is 0.5380s, whereas N = 200, T = 200, running time rises to 0.9830s, approximately twice than previous. If setting N = 400, T = 100, running time is 2.4130s, approximately 4 times than the first one.
Therefore, total running time is (in formula):

Running Time ~ T · N^2

### Answer Question 3 Again, Using the Weighted Quick-Union Datatype.

> Percolation Object: 8 (Field) + 4 (Pointer) + 4 (Padding) = 16 bytes.
> 4 integer: 16 bytes.
> 3 Reference (boolean [][], uf, uf_back): 24 bytes
> boolean[][] 16N + N^2 (1D Array and boolean value)
>
> WeightedQuickUnionUF:
> Percolation Object: 8 (Field) + 4 (Pointer) + 4 (Padding) = 16 bytes.
> Object: 16 bytes
> Two int[]: 2* (4 * (N^2 + 2) + 24) = 8N^2 + 64 bytes.
> int count: 4 bytes
> Reference: 2 * 8 = 16 bytes
>
> Total: 16 + 16 + 24 + 16N + N^2 + 2 * (16 + 16 + 8N^2 + 64 + 4 + 16) = 17N^2 + 16N + 336 ~ 17N^2. 
>

## Conclusion

From the comparison, it’s clear that `WeightedQuickUnionUF `is far more efficient than `QuickFindUF`, especially in large-scale Monte Carlo simulations. The key advantage of `WeightedQuickUnionUF `is its space-time tradeoff. It uses extra memory to store tree size information and parent relationships, ensuring smaller trees are merged into larger ones. This prevents excessive tree height and, combined with path compression, makes find operations nearly constant time (O(1)).

In contrast, `QuickFindUF` has a much higher time complexity for union operations (O(N²)), making its overall time complexity O(N⁴) in large grids. This is inefficient, particularly for large simulations.

Thus, `WeightedQuickUnionUF `offers a significant performance boost, making it the optimal choice for simulations that require many union-find operations, like percolation.