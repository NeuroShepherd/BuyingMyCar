

# PV = loan_amount
# PMT = monthly_payment
# i = interest_rate/month
# n = number_months


PMT = 457
i = .04/12
n = 60
PV = 15000

# Initial loan amount
# (PV = (PMT/i) * (1 - (1/(1+i)^n)))

# Monthly payments
(PV*i*((1+i)^n)/((1+i)^n - 1))

# Total loan cost
(PV*i*((1+i)^n)/((1+i)^n - 1))*n

# Loan cost - loan
(PV*i*((1+i)^n)/((1+i)^n - 1))*n - PV



calculate_loan_info <- function(loan_amount, interest_rate = 2.94, loan_duration = 60) {
  
  interest_rate <- interest_rate/100/12
  
  monthly_payment <- if (interest_rate > 0) {
    (loan_amount*interest_rate*((1+interest_rate)^loan_duration))/((1+interest_rate)^loan_duration - 1)
  } else 
    (loan_amount/loan_duration)
  
  tibble(loan_amount, interest_rate = interest_rate*12, loan_duration, monthly_payment) %>%
    mutate(total_loan_cost = monthly_payment*loan_duration,
           loan_differential = total_loan_cost - loan_amount)
  
}


calculate_loan_info(15000)



map2(c(2.94,3.74,4.24),c(60,60,72),
  ~tibble(car = c("Rav4","CRV"), cost = c(20000,18000)) %>%
    mutate(info = calculate_loan_info(loan_amount = cost*0.9,
                                      interest_rate = .x,
                                      loan_duration = .y)) 
) %>%
  bind_rows() %>%
  arrange(car) %>%
  View()


sim_data <- expand_grid(rates = c(0,1,2,3,4,5), duration = c(48,60,72))
map2(sim_data[["rates"]], sim_data[["duration"]],
     ~tibble(car = c("Rav4","CRV"), cost = c(20000,18000)) %>%
       mutate(info = calculate_loan_info(loan_amount = cost*0.9,
                                         interest_rate = .x,
                                         loan_duration = .y)) 
) %>%
  bind_rows() %>%
  arrange(car) %>%
  View()


