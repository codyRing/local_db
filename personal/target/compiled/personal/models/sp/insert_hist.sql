CREATE FUNCTION mint.insert_trans_history()
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
	,insert_date
)
SELECT
seed.date as trans_date
, seed.description
, seed.original_description
, seed.amount
, seed.transaction_type
, seed.category
, seed.account_name
, seed.labels
, seed.notes
,uuid_generate_v1() as recid
,timezone('utc', current_timestamp) as insert_date
	 FROM mint.transactions seed
		left join mint.transactions_history hist

		on
		seed.date = hist.trans_date and
 		seed.description = hist.description and
 		seed.original_description = hist.original_description and
		seed.amount = hist.amount and
 		seed.transaction_type = hist.transaction_type and
 		seed.category = hist.category and
 		seed.account_name = hist.account_name

where hist.recid is null;

	get diagnostics row_affects := row_count;
	return concat(row_affects::text,' :rows inserted');
end;
$BODY$;

ALTER FUNCTION mint.insert_trans_history()
    OWNER TO postgres;