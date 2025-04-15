public class Percolation {
    private final int n;
    private final int VIRTUAL_TOP = 0;
    private int VIRTUAL_BOTTOM;
    private boolean[][] grid;
    private WeightedQuickUnionUF uf;
    private WeightedQuickUnionUF uf_back;
    private int openSitesCount = 0;

    // Index: 0 is virtual top, 1 to N*N are the sites, N*N+1 is virtual bottom
    // Therefore, the index of site (i, j) is i * N + j + 1
    // Create N-by-N grid, with all sites blocked
    public Percolation(int N) {
        if (N <= 0) {
            throw new IllegalArgumentException("N must be greater than 0");
        }
        this.n = N;
        VIRTUAL_BOTTOM = N * N + 1;
        grid = new boolean[N][N];
        uf = new WeightedQuickUnionUF(VIRTUAL_BOTTOM + 1);
        uf_back = new WeightedQuickUnionUF(VIRTUAL_BOTTOM + 1);
    }

    // Check if the indices are valid
    private boolean isValid(int i, int j) {
        return i >= 0 && i < n && j >= 0 && j < n;
    }

    // Open a site (i, j) and mark it as open
    public void open(int i, int j) {
        if (!isValid(i, j)) {
            throw new IndexOutOfBoundsException("Index out of bounds");
        }
        int index = i * n + j + 1;
        if (!isOpen(i, j)) {
            openSitesCount++;
            grid[i][j] = true;
            if (i == 0) {
                uf.union(index, VIRTUAL_TOP);
                uf_back.union(index, VIRTUAL_TOP);
            }
            if (i == n - 1) {
                uf.union(index, VIRTUAL_BOTTOM);
            }
        }
        for (int[] direction : new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}) {
            int nowI = i + direction[0];
            int nowJ = j + direction[1];
            if (isValid(nowI, nowJ) && isOpen(nowI, nowJ)) {
                int newIndex = nowI * n + nowJ + 1;
                uf.union(index, newIndex);
                uf_back.union(index, newIndex);
            }
        }
    }

    // Check if a site (i, j) is open
    public boolean isOpen(int i, int j) {
        if (!isValid(i, j)) {
            throw new IndexOutOfBoundsException("Index out of bounds");
        }
        return grid[i][j];
    }

    // Check if a site (i, j) is connected to the top
    private boolean connectToTop(int i, int j) {
        int index = i * n + j + 1;
        return uf_back.find(index) == uf_back.find(VIRTUAL_TOP);
    }

    // Check if a site (i, j) is full
    public boolean isFull(int i, int j) {
        if (!isValid(i, j)) {
            throw new IndexOutOfBoundsException("Index out of bounds");
        }
        return isOpen(i, j) && connectToTop(i, j);

    }

    // Check if the system percolates
    public boolean percolates() {
        return uf.find(VIRTUAL_TOP) == uf.find(VIRTUAL_BOTTOM);
    }

    // Get the number of open sites
    public int getOpenSitesCount() {
        return openSitesCount;
    }
}
