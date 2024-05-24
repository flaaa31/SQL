/*create table progetto as*/
select
distinct(cl.id_cliente),
timestampdiff(year, cl.data_nascita, current_date) as eta,
count(case when segno = '-' then 1 end) as n_transazioni_uscita,
count(case when segno = '+' then 1 end) as n_transazioni_entrata,
coalesce(sum(case when segno = '-' then importo end),0) as importo_uscita,
coalesce(sum(case when segno = '+' then importo end),0) as importo_entrata,
count(distinct co.id_conto) as numero_conti,
count(distinct(case when co.id_tipo_conto = 0 then co.id_conto end)) as n_conti_base,
count(distinct(case when co.id_tipo_conto = 1 then co.id_conto end)) as n_conti_business,
count(distinct(case when co.id_tipo_conto = 2 then co.id_conto end)) as n_conti_privati,
count(distinct(case when co.id_tipo_conto = 3 then co.id_conto end)) as n_conti_famiglie,
count(case when tt.id_tipo_transazione = 3 then 1 end) as n_acquisti_amazon,
count(case when tt.id_tipo_transazione = 4 then 1 end) as n_rate_mutuo,
count(case when tt.id_tipo_transazione = 5 then 1 end) as n_hotel,
count(case when tt.id_tipo_transazione = 6 then 1 end) as n_biglietti_aerei,
count(case when tt.id_tipo_transazione = 7 then 1 end) as n_spesa_supermercato,
count(case when tt.id_tipo_transazione = 0 then 1 end) as n_stipendio,
count(case when tt.id_tipo_transazione = 1 then 1 end) as n_pensione,
count(case when tt.id_tipo_transazione = 2 then 1 end) as n_dividendi,
coalesce(sum(case when co.id_tipo_conto = 0 and segno = "-" then importo end),0) as importo_uscita_base, 
coalesce(sum(case when co.id_tipo_conto = 1 and segno = "-" then importo end),0) as importo_uscita_business,
coalesce(sum(case when co.id_tipo_conto = 2 and segno = "-" then importo end),0) as importo_uscita_privati,
coalesce(sum(case when co.id_tipo_conto = 3 and segno = "-" then importo end),0) as importo_uscita_famiglie,
coalesce(sum(case when co.id_tipo_conto = 0 and segno = "+" then importo end),0) as importo_entrata_base,
coalesce(sum(case when co.id_tipo_conto = 1 and segno = "+" then importo end),0) as importo_entrata_business,
coalesce(sum(case when co.id_tipo_conto = 2 and segno = "+" then importo end),0) as importo_entrata_privati,
coalesce(sum(case when co.id_tipo_conto = 3 and segno = "+" then importo end),0) as importo_entrata_famiglie
from
banca.cliente cl
left join banca.conto co
on cl.id_cliente = co.id_cliente
left join banca.tipo_conto tc
on co.id_tipo_conto = tc.id_tipo_conto
left join banca.transazioni tr
on co.id_conto = tr.id_conto
left join banca.tipo_transazione tt
on tr.id_tipo_trans = tt.id_tipo_transazione
group by 1,2