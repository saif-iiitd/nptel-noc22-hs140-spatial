### 3. Run regressions

# Our regression equation
reg_eqn <- POSTMONSOON~RFL_TY+TEMP_TY+PCTCROPAREA_LY

# First simple OLS
fit.OLS <- lm(reg_eqn, data = upL3.sp.1)

# Look at the results
summary(fit.OLS)

# Get the residuals for each sub-district
upL3.sp.1$residuals <- residuals(fit.OLS)

# Plot the residuals
spplot(upL3.sp.1, "residuals", col="black")

# Check for residual spatial auto-correlation - Moran's I Test
moran.mc(upL3.sp.1$residuals, W.listw, 999)


# SAR: Spatial Auto-Regressive Model
# Note: We now also pass in the weights matrix W.listw
fit.sAR <- lagsarlm(reg_eqn, data = upL3.sp.1, W.listw)

# Look at the results
summary(fit.sAR)

# Get the residuals for each sub-district
upL3.sp.1$residuals <- residuals(fit.sAR)

# Plot the residuals
spplot(upL3.sp.1, "residuals", col="black")

# Check for residual spatial auto-correlation - Moran's I Test
moran.mc(upL3.sp.1$residuals, W.listw, 999)


# SLE: Spatial Error Model
fit.SLE <- errorsarlm(reg_eqn, data=upL3.sp.1, W.listw, tol.solve=1.0e-30)

# Look at the results
summary(fit.SLE)

# Get the residuals for each sub-district
upL3.sp.1$residuals <- residuals(fit.SLE)

# Plot the residuals
spplot(upL3.sp.1, "residuals", col="black")

# Check for residual spatial auto-correlation - Moran's I Test
moran.mc(upL3.sp.1$residuals, W.listw, 999)


# SLX: Spatial Lag in X Model
fit.SLX <- lmSLX(reg_eqn, upL3.sp.1, W.listw)

# Look at the results
summary(fit.SLX)

# Get the residuals for each sub-district
upL3.sp.1$residuals <- residuals(fit.SLX)

# Plot the residuals
spplot(upL3.sp.1, "residuals", col="black")

# Check for residual spatial auto-correlation - Moran's I Test
moran.mc(upL3.sp.1$residuals, W.listw, 999)
