/* Retrieve a list of items that are over 30 days overdue to Link+ libraries with bib-level hold count
	Created AGW 3/2026 */

WITH hold_counts AS (
    SELECT
        h.record_id AS bib_record_id,
        COUNT(h.id) AS hold_count
    FROM
        sierra_view.hold h
    GROUP BY
        h.record_id
),

	item_totals AS (SELECT COUNT(DISTINCT CASE 
        WHEN i.item_status_code NOT IN ('$', 'n', 'w', 'm') THEN i.id 
        ELSE NULL 
    END) AS item_totals, brp.bib_record_id

FROM sierra_view.item_record i 
JOIN sierra_view.bib_record_item_record_link bri ON i.id = bri.item_record_id
JOIN sierra_view.bib_record_property brp ON bri.bib_record_id = brp.bib_record_id

GROUP BY brp.bib_record_id)

SELECT
    DISTINCT i.location_code AS "Location",
    CASE
        WHEN pei.index_entry IS NULL THEN UPPER(peb.index_entry)
        ELSE UPPER(pei.index_entry)
    END AS "Call#",
    brp.best_author AS "Author",
    brp.best_title AS "Title",
    i.barcode AS "Barcode",
	i.year_to_date_checkout_total AS "YTD CIRC", 
	i.last_year_to_date_checkout_total AS "LYCIRC", 
	COALESCE(hc.hold_count, 0) AS "Holds",
	it.item_totals AS "Items",
	c.due_gmt::date AS "Due Date",
    'b' || rmb.record_num || 'a' AS "Bib Record Num"
    
FROM
    sierra_view.item_view i
JOIN sierra_view.record_metadata rmi ON rmi.id = i.id AND rmi.record_type_code = 'i'
JOIN sierra_view.bib_record_item_record_link bri ON bri.item_record_id = i.id
JOIN sierra_view.record_metadata rmb ON rmb.id = bri.bib_record_id AND rmb.record_type_code = 'b'
JOIN sierra_view.phrase_entry peb ON peb.record_id = bri.bib_record_id AND peb.index_tag = 'c'
LEFT JOIN sierra_view.phrase_entry pei ON pei.record_id = i.id AND pei.index_tag = 'c'
JOIN sierra_view.bib_record_property brp ON brp.bib_record_id = bri.bib_record_id
LEFT JOIN sierra_view.checkout c ON c.item_record_id=i.id
LEFT JOIN sierra_view.varfield_view v ON v.record_id=i.id
LEFT JOIN hold_counts hc ON hc.bib_record_id = bri.bib_record_id
LEFT JOIN item_totals it ON it.bib_record_id = bri.bib_record_id
WHERE
    i.item_status_code = '@'
    AND c.due_gmt::date<=now()- interval '30 days'
	AND v.field_content LIKE '%requested by%'


ORDER BY
    i.location_code,
    "Call#",
    brp.best_author,
    brp.best_title;