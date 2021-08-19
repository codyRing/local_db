--SELECT
--        t.TransDate AS transdate,
--        t.Description AS description,
--        t.OriginalDescription AS originaldescription,
--        t.Amount AS amount,
--        t.TransactionType AS TransactionType,
--        t.Category AS category,
--        t.AccountName AS AccountName,
--        t.Labels AS Labels,
--        t.Notes AS Notes,
--        t.id AS id
--    FROM
--        mint.txn t
--        JOIN mint.budget b ON ((t.Category = b.Category)))
--    WHERE
--        (b.Discretionary = 1)