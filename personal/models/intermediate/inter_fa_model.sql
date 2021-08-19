with
trans as (select * from {{ref('stg_transactions_history_snapshot_model')}}),
budget as (select * from {{ref('stg_budget_model')}})

select
row_number() over (partition by
				  (date_part('year',t.trans_date))
				   ,(date_part('month',t.trans_date))
				   ,t.category
				   order by
				  (date_part('year',t.trans_date)) desc
				   ,(date_part('month',t.trans_date)) desc
				   ,t.trans_date desc
				  ),
        t.trans_date,
        t.description,
        t.original_description,
        t.amount,
        t.transaction_type,
        t.category,
        t.account_name,
        t.labels,
        t.notes,
        t.recid
from trans t
    join budget b
        on t.category = b.category
        where b.invest = 1
