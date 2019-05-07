---
title: "What drives the functional response to logging in Amazonia?"
output: 
  html_document:
    theme: yeti
    keep_md: true
    toc: true
    toc_float: true
---




In this study we model the functional resistance and resilience of trees recruitement to disturbance (here selective logging), and their spatial variation in Amazonia. 

# Data visualisation

## by cohort


## Traits trajectory {.tabset .tabset-fade .tabset-pills}

Traits chosen: 

- $DBH95$: DBH 95th percentile (per species) as a proxy of the stature

- $logSeedMass$: median seed mass (log-transformed) as a proxy of the dispersal strategy

- $SLA$: median specific leaf area, as a proxy of the assimilation strategy and leaf economic spectrum

- $WD$: median wood density, as a proxy of growth rate and mechanical support

We separate two size classes: 

- Small trees, ie trees $\leq$ 35 cm dbh

- Big trees, ie trees $>$ 35 cm dbh

Here are represented for each size class the mean trait value, weighted by the estimated above ground biomass (AGB) of each individual.



### Jenaro 
![](main_TmFO_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

### Chico Bocao 
![](main_TmFO_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

### Cumaru 
![](main_TmFO_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

### INPA 
![](main_TmFO_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

### Iracema 
![](main_TmFO_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

### La Chonta 
![](main_TmFO_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

### Peteco 
![](main_TmFO_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

### Paracou 
![](main_TmFO_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

### Paragominas 
![](main_TmFO_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

### Tabocal 
![](main_TmFO_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

### Tapajos 
![](main_TmFO_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

### Tortue 
![](main_TmFO_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


## Recruits most common genuses and their impact on mean weighted traits {.tabset .tabset-pills}





genus2: genuses with > 10% of the recruits biomass

### Jenaro 
![](main_TmFO_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

### Chico Bocao 
![](main_TmFO_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

### Cumaru 
![](main_TmFO_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

### INPA 
![](main_TmFO_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

### Iracema 
![](main_TmFO_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

### La Chonta 
![](main_TmFO_files/figure-html/unnamed-chunk-21-1.png)<!-- -->

### Peteco 
![](main_TmFO_files/figure-html/unnamed-chunk-22-1.png)<!-- -->

### Paracou 
![](main_TmFO_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

### Paragominas 
![](main_TmFO_files/figure-html/unnamed-chunk-24-1.png)<!-- -->

### Tabocal 
![](main_TmFO_files/figure-html/unnamed-chunk-25-1.png)<!-- -->

### Tapajos 
![](main_TmFO_files/figure-html/unnamed-chunk-26-1.png)<!-- -->

### Tortue 
![](main_TmFO_files/figure-html/unnamed-chunk-27-1.png)<!-- -->


# Calibrating the stan model

For each trait $k$, the mean biomass-weighted trait of small trees (MWT) trajectory at census $c$ in plot $p$ in site $s$ was modelled as:

$$  dT_{k,c,p,s} = \frac{T_{k,c,p,s} - T0_{k,p,s}}{T0_{k,p,s}} \sim \mathcal{N}\left( \mu_{k,c,p,s}\text{ , } \left(\frac{\sigma_k}{size_p}\right)^2\right)$$

with 

$$ \mu_{k,c,p,s} = \left(\Delta_{k,p,s} \cdot  \frac{t_c}{tmax_{k,p,s}} \cdot exp\left(1-\frac{t_c}{tmax_{k,p,s}}\right)\right)^{\theta_{k,p,s}} $$

- $c$ the census, and $t_c$ the time since logging (in years) at census $c$, 

- $T0_{k,p,s}$ the pre-logging trait value of the community in plot $p$ in site $s$.

- $\Delta_{k,p,s}$ is the maximum value (relative to the final value) of the hump that follows logging and the creation of logging gaps. $\Delta_{k,p,s} \sim \mathcal{N} (\mu_{\Delta ks}, \sigma_{\Delta}^2)$, with $\mu_{\Delta ks}$ and $\sigma_{\Delta}$ are respectively the mean and standard deviation of $\Delta$ for trait $k$ in site $s$.

- $tmax_{k,p,s}$ is the time when the maximum value of the hump is reached. $tmax_{k,p} = 0$ for control plots and in logged plots $tmax_{k,p} \sim \mathcal{N} (\mu m_{ k}, \sigma m^2)$ where $\mu m_{k}$ and $\sigma m$ are respectively the mean and standard deviation of $tmax$ for trait $k$.

- $\theta_k$ is a shape parameter that controls the width of the hump; when it increases, the hump is narrower.  

- $size_p$ is the size of plot $p$



## Parameters {.tabset .tabset-pills}
(check parameters correlation)

### Delta
![](main_TmFO_files/figure-html/unnamed-chunk-29-1.png)<!-- -->

### tmax
![](main_TmFO_files/figure-html/unnamed-chunk-30-1.png)<!-- -->

### theta
![](main_TmFO_files/figure-html/unnamed-chunk-31-1.png)<!-- -->

### theta vs tmax
![](main_TmFO_files/figure-html/unnamed-chunk-32-1.png)<!-- -->

### Delta vs tmax
![](main_TmFO_files/figure-html/unnamed-chunk-33-1.png)<!-- -->

### theta vs Delta
![](main_TmFO_files/figure-html/unnamed-chunk-34-1.png)<!-- -->


## Predictions {.tabset .tabset-pills}





### Jenaro 
![](main_TmFO_files/figure-html/unnamed-chunk-37-1.png)<!-- -->

### Chico Bocao 
![](main_TmFO_files/figure-html/unnamed-chunk-38-1.png)<!-- -->

### Cumaru 
![](main_TmFO_files/figure-html/unnamed-chunk-39-1.png)<!-- -->

### INPA 
![](main_TmFO_files/figure-html/unnamed-chunk-40-1.png)<!-- -->

### Iracema 
![](main_TmFO_files/figure-html/unnamed-chunk-41-1.png)<!-- -->

### La Chonta 
![](main_TmFO_files/figure-html/unnamed-chunk-42-1.png)<!-- -->

### Peteco 
![](main_TmFO_files/figure-html/unnamed-chunk-43-1.png)<!-- -->

### Paracou 
![](main_TmFO_files/figure-html/unnamed-chunk-44-1.png)<!-- -->

### Paragominas 
![](main_TmFO_files/figure-html/unnamed-chunk-45-1.png)<!-- -->

### Tabocal 
![](main_TmFO_files/figure-html/unnamed-chunk-46-1.png)<!-- -->

### Tapajos 
![](main_TmFO_files/figure-html/unnamed-chunk-47-1.png)<!-- -->

### Tortue 
![](main_TmFO_files/figure-html/unnamed-chunk-48-1.png)<!-- -->



# Adding covariates to the model

## Model 

$$ \Delta_{p,k} = loss \cdot (\lambda_0 + \sum \lambda_m Cov_{m,p}) $$
Covariates are centered and scaled. 



## Linear model variable selection {.tabset .tabset-pills}



### DBH95

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">mean</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss rel</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.32</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.44&nbsp;&ndash;&nbsp;-0.19</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:prec_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">5.22</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">2.32&nbsp;&ndash;&nbsp;8.13</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.002</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:seas_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-4.98</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-7.91&nbsp;&ndash;&nbsp;-2.05</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.003</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:dry_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-4.36</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-6.86&nbsp;&ndash;&nbsp;-1.86</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.002</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:cwd_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-5.72</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-8.84&nbsp;&ndash;&nbsp;-2.60</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:Depth_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.09</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.67&nbsp;&ndash;&nbsp;-0.52</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:Psand_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.46</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-2.38&nbsp;&ndash;&nbsp;-0.54</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.005</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:CEC_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.58</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.97&nbsp;&ndash;&nbsp;-0.18</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.008</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:CFr_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-2.59</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-4.02&nbsp;&ndash;&nbsp;-1.16</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.002</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:smort_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-2.86</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-4.38&nbsp;&ndash;&nbsp;-1.35</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">35</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">R<sup>2</sup> / adjusted R<sup>2</sup></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.914 / 0.880</td>
</tr>

</table>

### SLA


<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">mean</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss rel</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.14</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.01&nbsp;&ndash;&nbsp;0.27</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.040</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:prec_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.00</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.60&nbsp;&ndash;&nbsp;-0.39</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.003</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:seas_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">1.03</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.56&nbsp;&ndash;&nbsp;1.50</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:dry_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.63</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.13&nbsp;&ndash;&nbsp;1.14</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.021</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:rad_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.35</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.09&nbsp;&ndash;&nbsp;0.60</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.012</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:cwd_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.88</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.58&nbsp;&ndash;&nbsp;1.18</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:Depth_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.33</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.53&nbsp;&ndash;&nbsp;-0.13</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.003</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:CEC_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.23</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.08&nbsp;&ndash;&nbsp;0.38</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.006</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">35</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">R<sup>2</sup> / adjusted R<sup>2</sup></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.847 / 0.802</td>
</tr>

</table>

### logSeedMass


<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">mean</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss rel</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.16</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.25&nbsp;&ndash;&nbsp;-0.07</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.002</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:prec_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.19</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.04&nbsp;&ndash;&nbsp;0.33</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.015</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:rad_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.37</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.04&nbsp;&ndash;&nbsp;0.71</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.036</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:CFr_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.56</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-1.06&nbsp;&ndash;&nbsp;-0.07</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.032</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">35</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">R<sup>2</sup> / adjusted R<sup>2</sup></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.877 / 0.861</td>
</tr>

</table>

### woodDensity


<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">mean</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss rel</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.05</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.12&nbsp;&ndash;&nbsp;0.03</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.203</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:prec_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.42</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.78&nbsp;&ndash;&nbsp;-0.06</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.029</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:seas_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.26</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.52&nbsp;&ndash;&nbsp;-0.01</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.051</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:rad_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.25</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.36&nbsp;&ndash;&nbsp;-0.15</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:Psand_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.31</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.60&nbsp;&ndash;&nbsp;-0.02</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.046</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:CEC_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.36</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.66&nbsp;&ndash;&nbsp;-0.06</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.024</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">loss_rel:BkD_sc</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.59</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">-0.94&nbsp;&ndash;&nbsp;-0.23</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>0.003</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">35</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">R<sup>2</sup> / adjusted R<sup>2</sup></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.961 / 0.952</td>
</tr>

</table>

## Adding a subset of environmental covariates to the Bayesian hierarchical model {.tabset .tabset-pills}

![](main_TmFO_files/figure-html/unnamed-chunk-59-1.png)<!-- -->



![](main_TmFO_files/figure-html/unnamed-chunk-61-1.png)<!-- -->![](main_TmFO_files/figure-html/unnamed-chunk-61-2.png)<!-- -->

### Option 1

![](main_TmFO_files/figure-html/unnamed-chunk-62-1.png)<!-- -->

![](main_TmFO_files/figure-html/unnamed-chunk-63-1.png)<!-- -->



![](main_TmFO_files/figure-html/unnamed-chunk-65-1.png)<!-- -->

### Option 2
![](main_TmFO_files/figure-html/unnamed-chunk-66-1.png)<!-- -->

![](main_TmFO_files/figure-html/unnamed-chunk-67-1.png)<!-- -->



![](main_TmFO_files/figure-html/unnamed-chunk-69-1.png)<!-- -->

### Option 3
![](main_TmFO_files/figure-html/unnamed-chunk-70-1.png)<!-- -->

![](main_TmFO_files/figure-html/unnamed-chunk-71-1.png)<!-- -->



![](main_TmFO_files/figure-html/unnamed-chunk-73-1.png)<!-- -->

## Testing the initial composition and diversity of the community of resistance 



### Correlations per site {.tabset .tabset-pills}

#### Wood density
![](main_TmFO_files/figure-html/unnamed-chunk-75-1.png)<!-- -->![](main_TmFO_files/figure-html/unnamed-chunk-75-2.png)<!-- -->

#### DBH95
![](main_TmFO_files/figure-html/unnamed-chunk-76-1.png)<!-- -->![](main_TmFO_files/figure-html/unnamed-chunk-76-2.png)<!-- -->

#### SLA
![](main_TmFO_files/figure-html/unnamed-chunk-77-1.png)<!-- -->![](main_TmFO_files/figure-html/unnamed-chunk-77-2.png)<!-- -->

#### seed mass
![](main_TmFO_files/figure-html/unnamed-chunk-78-1.png)<!-- -->![](main_TmFO_files/figure-html/unnamed-chunk-78-2.png)<!-- -->

### Correlations per plot {.tabset .tabset-pills}

#### Wood density
![](main_TmFO_files/figure-html/unnamed-chunk-79-1.png)<!-- -->

#### DBH95
![](main_TmFO_files/figure-html/unnamed-chunk-80-1.png)<!-- -->

#### SLA
![](main_TmFO_files/figure-html/unnamed-chunk-81-1.png)<!-- -->

#### seed mass
![](main_TmFO_files/figure-html/unnamed-chunk-82-1.png)<!-- -->


### with FD per trait



![](main_TmFO_files/figure-html/unnamed-chunk-84-1.png)<!-- -->

### with FD of all trees < 35 cm dbh (all 4 traits together)



![](main_TmFO_files/figure-html/unnamed-chunk-86-1.png)<!-- -->

