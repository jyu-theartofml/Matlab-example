# Example Matlab codes

## Acetate time point
<p> Bioassay was performed to measure concentrations of acetate in rat serum samples. Acetate level above baseline concentration is generated from metabolism of ethanol since the rodents in this study were dosed with different amount of alcohol. summary.m is a code that takes acetate concentration time point values from individual samples and group them by the animal strains and dosage groups. The average and standard deviation of the mean (SEM) were calculated for time point plot. Area under the curve (AUC) for each animal/sample was calculated using the trapezoidal rule (trapz function) to estimate the total amount of acetate generated. Since acetate level is proportional to alcohol blood level, the acetate amount and GC data on ethanol amount will shed light on how each strain of rat metabolizes alcohol. </p><p>Note:plots will be posted at later date when data are published.</p>

## Portfolio efficient frontier
<p>In evaluating portfolio diversification, efficient frontier (introduced by Nobel Laureate Harry Markowitz) can be used to find the optimal arrangement of the assets that offers the highest expected return for a given measurement of risk (standard devidation in this case). A portofolio that 'under performs' will lie below or lean to the right of the efficient frontier curve, indicating that it's not yielding as much return as it potentially could.The code (portfolio.m) was ran with my 401K data, and as shown in the plot below the portfolio assets needed some re-adjustment.</p>
<p align="center"><img src ='vanguard efficient frontier.jpg'></p>


Reference:http://www.investopedia.com/terms/e/efficientfrontier.asp
