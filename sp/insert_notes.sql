CREATE or replace FUNCTION mint.insert_notes()
    RETURNS text
    LANGUAGE plpgsql

AS $BODY$
declare
	row_affects int:=0;
begin
insert into mint.transactions_history(
	trans_date
	,description
	,original_description
	,amount
	,transaction_type
	,category
	,account_name
	,labels
	,notes
	,recid
	,start_date
)
------Category_update
select
seed.date as trans_date
, seed.description
, seed.original_description
, seed.amount
, seed.transaction_type
, seed.category
, seed.account_name
, seed.labels
, seed.notes
, hist.recid
,timezone('utc', current_timestamp) as start_date
from mint.transactions seed
	 join mint.transactions_history hist

	on
	seed.date = hist.trans_date and
	seed.amount = hist.amount  and
 	seed.category = hist.category and
 	seed.description = hist.description and
 	seed.original_description=hist.original_description
--	coalesce(seed.notes,'1') = coalesce(hist.notes,'1')


where
coalesce(seed.notes,'1') <> coalesce(hist.notes,'1')
ON CONFLICT  DO NOTHING
;

	get diagnostics row_affects := row_count;
	return concat(row_affects::text,' :new notes');
end;
$BODY$;

ALTER FUNCTION mint.insert_notes()
    OWNER TO postgres;