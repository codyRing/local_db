with
trans as (select * from {{ref('stg_transactions_history_snapshot_model')}})

select
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
    where t.transaction_type like 'credit'
    and t.category not in ('Credit Card Payment','Transfer')
    and t.account_name in ('PREMIER PLUS CKG','TOTAL BUS CHK','BUS COMPLETE CHK')
    order by t.trans_date desc