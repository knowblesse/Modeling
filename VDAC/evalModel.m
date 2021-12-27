function likelihood = evalModel(param, V_high, V_low, Exp_high_mean, Exp_high_sd, Exp_low_mean, Exp_low_sd)

Exp_high = normpdf(linspace(param(1), param(2), 30), Exp_high_mean, Exp_high_sd);
Exp_low  = normpdf(linspace(param(1), param(2), 30), Exp_low_mean, Exp_low_sd);

likelihood = - (V_high * Exp_high' + V_low * Exp_low');

end
