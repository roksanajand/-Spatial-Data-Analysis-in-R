# Spatial Data Analysis in R

This project focuses on spatial data analysis, using various geospatial techniques and R libraries such as `spatstat`, `sf`, and `ggplot2` to analyze and visualize spatially distributed data. The project contains tasks such as:

1. **Generating Random Point Patterns (Poisson, Strauss, Matérn Processes)**:
   - Generation of different types of point processes, such as Poisson, Strauss, and Matérn processes, with varying intensity functions. Each process was generated over a circular window and visualized to assess spatial distribution.

2. **Analyzing Point Process Characteristics**:
   - For each generated process, several analyses were performed, including computing nearest neighbor distances, and comparing the distribution of points with histograms.
   - The spatial properties of each point pattern were analyzed using functions like `Gest` and `Kest` to compute spatial statistics such as the G-function and K-function, which describe the distribution of points at various distances.

3. **Intensity Estimation and Residuals**:
   - Intensity estimation was performed for each point process using kernel density estimation methods.
   - Residuals of the models were calculated and visualized to assess model fit and to understand the spatial structure of the data.

4. **Point Process Model Fitting**:
   - Models were fitted to point patterns using `ppm` (point process model), and trend surfaces were introduced to model intensity as a function of spatial coordinates.
   - A trend model with a log-linear intensity function was fitted, and residuals were analyzed for each process.

5. **Comparison of Process Models and Simulation**:
   - Simulated point processes were generated based on the fitted models using `rmh` and analyzed for spatial patterns.
   - The function `density` was used to estimate the intensity for the generated points, and the result was compared visually to the actual point patterns.

6. **Geospatial Visualization**:
   - The project also involved the visualization of spatial data on maps, including plotting offenses in Kraków, with neighborhood boundaries overlaid. Various R packages were used to generate clear and informative visualizations.

7. **Diagnostics**:
   - Diagnostic tests were applied to assess the fit and assumptions of the point process models, including checking residuals and performing tests for point pattern uniformity.

The project used R's spatial packages to build models, estimate spatial intensity functions, visualize data, and conduct diagnostics, helping understand the spatial distribution of points in different contexts.
