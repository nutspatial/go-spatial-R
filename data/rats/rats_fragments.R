rats_list <- list(x = c(8.0, 15.0, 22.0, 29.0, 36.0), xbar = 22, N = 30, T = 5,   
                  Y = structure(
                      .Data = c(151, 199, 246, 283, 320,
                                145, 199, 249, 293, 354,
                                147, 214, 263, 312, 328,
                                155, 200, 237, 272, 297,
                                135, 188, 230, 280, 323,
                                159, 210, 252, 298, 331,
                                141, 189, 231, 275, 305,
                                159, 201, 248, 297, 338,
                                177, 236, 285, 350, 376,
                                134, 182, 220, 260, 296,
                                160, 208, 261, 313, 352,
                                143, 188, 220, 273, 314,
                                154, 200, 244, 289, 325,
                                171, 221, 270, 326, 358,
                                163, 216, 242, 281, 312,
                                160, 207, 248, 288, 324,
                                142, 187, 234, 280, 316,
                                156, 203, 243, 283, 317,
                                157, 212, 259, 307, 336,
                                152, 203, 246, 286, 321,
                                154, 205, 253, 298, 334,
                                139, 190, 225, 267, 302,
                                146, 191, 229, 272, 302,
                                157, 211, 250, 285, 323,
                                132, 185, 237, 286, 331,
                                160, 207, 257, 303, 345,
                                169, 216, 261, 295, 333,
                                157, 205, 248, 289, 316,
                                137, 180, 219, 258, 291,
                                153, 200, 244, 286, 324),
                      .Dim = c(30,5)))

with(rats_list, 
     data.frame(matrix(Y, ncol=T, byrow = T))) %>%
    dplyr::mutate(ID = factor(1:n())) %>%
    tidyr::gather(key, value, -ID) %>%
    dplyr::mutate(time = rats_list$x[parse_number(key)]) %>%
    dplyr::select(ID, time, weight = value) -> rats_df
    
    
ggplot(data=rats_df, aes(x=time, y=weight)) +
    geom_line(aes(group=ID)) + theme_bw()

mgcv::gam(data=rats_df, weight ~  time) %>%
    summary()

mgcv::gam(data=rats_df, weight ~ s(ID, bs="re") + time) %>%
    residuals()

mgcv::gam(data=rats_df, weight ~ s(ID, bs="re") + s(time, ID, bs="re")) %>%
    dplyr::mutate(.data = rats_df,
                  pred = predict(object = ., newdata = rats_df))

model_results <- list(`Fixed effects`= 
         as.formula("weight ~  time"),
     `Random intercept, fixed slope` = 
         as.formula("weight ~ s(ID, bs='re') + time"),
     `Random slope, fixed intercept` = 
         as.formula("weight ~ s(ID, time, bs='re')"),
     `Random intercept and slope` =
         as.formula("weight ~ s(ID, bs='re') + s(time, ID, bs='re')")) %>%
    purrr::map(~mgcv::gam(data=rats_df, formula = .x)) %>%
    purrr::map(~mgcv::predict.gam(object = .x, newdata=rats_df)) %>%
    purrr::map_df(~bind_cols(rats_df, data.frame(weight_pred = c(.x))),
                  .id = "Model") %>%
    dplyr::mutate(Model = forcats::fct_inorder(Model))


ggplot(data=model_results, aes(x=time, y=weight_pred)) +
    geom_line(aes(group=interaction(Model, ID)),
              alpha = 0.5) + 
    facet_wrap(~Model) +
    theme_bw() + theme(legend.position = "bottom") +
    geom_point(data = rats_df, aes(y = weight)) 
