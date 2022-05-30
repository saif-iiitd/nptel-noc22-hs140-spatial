### 3. Run regressions

# First simple OLS
fit.OLS <- lm(POSTMONSOON~RFL_TY+TEMP_TY+PCTCROPAREA_LY, data = upL3.sp)

# SAR
fit.sAR <- lagsarlm(POSTMONSOON~RFL_TY+TEMP_TY+PCTCROPAREA_LY, data = upL3.sp,
                    W.listw)