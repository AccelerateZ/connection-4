public class PercolationStats {

    private int N = 0;
    private int T = 0;
    private double[] thresholds;
    private double mean = 0.0;
    private double stddev = 0.0;
    private final double CONFIDENCE_95 = 1.96;

    // Perform T independent experiments on an N-by-N grid
    public PercolationStats(int N, int T) {
        if (N <= 0 || T <= 0) {
            throw new IllegalArgumentException("N and T must be greater than 0");
        }
        this.N = N;
        this.T = T;
        thresholds = new double[T];

        for (int i = 0; i < T; i++) {
            Percolation percolation = new Percolation(N);
            while (!percolation.percolates()) {
                int randomRow = StdRandom.uniformInt(N);
                int randomCol = StdRandom.uniformInt(N);
                percolation.open(randomRow, randomCol);
            }
            int openSites = percolation.getOpenSitesCount();
            thresholds[i] = (double) openSites / (double) (N * N);
        }
        mean = StdStats.mean(thresholds);
        stddev = StdStats.stddev(thresholds);
    }

    // Sample mean of percolation threshold
    public double mean() {
        return mean;
    }

    // Sample standard deviation of percolation threshold
    public double stddev() {
        return stddev;
    }

    // Low endpoint of 95% confidence interval
    public double confidenceLo() {
        return mean - CONFIDENCE_95 * stddev / Math.sqrt(thresholds.length);
    }

    // High endpoint of 95% confidence interval
    public double confidenceHi() {
        return mean + CONFIDENCE_95 * stddev / Math.sqrt(thresholds.length);
    }

    public static void main(String[] args) {
        int size = StdIn.readInt();
        int trials = StdIn.readInt();
        Stopwatch timer = new Stopwatch();
        PercolationStats stats = new PercolationStats(size, trials);
        double timeElapsing = timer.elapsedTime();
        System.out.println("Mean: " + String.format("%.4f", stats.mean()));
        System.out.println("Stddev: " + String.format("%.4f", stats.stddev()));
        System.out.println("95% confidence interval: [" + String.format("%.4f", stats.confidenceLo()) + ", "
                + String.format("%.4f", stats.confidenceHi()) + "]");
        System.out.println("Time elapsed: " + String.format("%.4f", timeElapsing) + " seconds");
    }
}
