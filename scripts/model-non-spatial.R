################################################################################
#                          Introduction to Modelling I
#               Statistical modelling with the Generalised Linear Model
################################################################################


# ------------------------------------------------------------ LINEAR MODEL ----

# ---- Read in data ------------------------------------------------------------
rats_df <- read_csv(
  file = "./data/rats/rats.csv", 
  col_types = list(ID = 'f')
  )

## Plot the data ----
rats_df |> 
  ggplot(aes(x = time, y = weight)) +
  geom_line(aes(group = ID)) +
  theme_minimal() +
  xlab("Time") +
  ylab("Weight gain")

## Fit a model showing the weight of the rats as a function of their age ----
rats_lm <- lm(
  data = rats_df,
  formula = weight ~ time
)

## Model summary ----
summary(rats_lm)

## Plot the model residuals against the fitted values ----
rats_df |> 
  ggplot(aes(x = fitted(rats_lm), y = residuals(rats_lm))) +
  geom_point() +
  geom_smooth(stat = "smooth", se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals")

### Question: do residulas look IDD: No!
#### The variance increases as the time advances 
#### The risidulas are deviated from zero. 

# ------------------------------------------------ GENERALIZED LINEAR MODEL ----
adm2_geojson <- st_read(
  dsn = "data/haiti/adm2.geojson",
  stringsAsFactors = F,
  quiet = TRUE
)

## Plot of "dtp3coverage2016" and "urbanpct" variables ----
adm2_geojson |> 
  ggplot(aes(x = urbanpct, y = dtp3coverage2016 / 100)) +
  geom_point() +
  geom_smooth(method = "loess", se = TRUE) +
  xlab("Population living in urban areas") +
  ylab("Population vaccinated with DTP3") +
  scale_y_continuous(limits = c(0,1), labels = label_percent()) + 
  scale_x_continuous(limits = c(0,1), labels = label_percent()) + 
  theme_minimal() 


## Fit a model ----
# In order to fit the model, we need to tell glm() how many successes and 
# failures we had. In the data frame, the relevant variables are

### Get the number of failutes from th
adm2_geojson <- adm2_geojson |> 
  mutate(
    vacc_fail = vacc_denom - vacc_num
    )

### Fit a model ----
adm2_binom <- glm(
  data = adm2_geojson,
  cbind(vacc_num, vacc_fail) ~ urbanpct,
  family = 'binomial'
)

## Show the model summary ----
summary(adm2_binom)

## Show the model summary as a tibble ----
broom::tidy(adm2_binom, conf.int = TRUE)

## Or get a glance of the model statistics ----
broom::glance(adm2_binom)

## Check the predicted vaccine per region ----
head(fitted.values(adm2_binom))

## Or this ----
head(predict(adm2_binom, type = 'response'))

## Or use the `augment()` function ----
broom::augment(adm2_binom)

## Add the predicted values into the data frame ----
adm2_geojson <- adm2_geojson |> 
  mutate(coverage_pred = predict(object = adm2_binom, 
                            newdata = adm2_geojson, 
                            type = "response"
                            )
    )

## Plot the results ----
ggplot(data= adm2_geojson, 
       aes(x = vacc_num/vacc_denom, y = coverage_pred)) +
  geom_point() +
  xlab('Observed') + ylab('Predicted') +
  theme_minimal() + 
  geom_abline(intercept = 0, slope = 1) +
  scale_x_continuous(limits = c(0,1), labels = percent_format()) +
  scale_y_continuous(limits = c(0,1), labels = percent_format()) +
  coord_equal()


adm2_geojson |> 
  ggplot() +
  geom_sf(aes(fill = residuals)) +
  scale_fill_gradient2(midpoint = 0, name = "Residuals") +
  theme_void() +
  theme(axis.text = element_blank()) +
  scale_fill_viridis_c()


