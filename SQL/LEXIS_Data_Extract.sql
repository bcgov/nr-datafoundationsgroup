SELECT
  ep.EXPORT_PERMIT_DETAIL_NUMBER,
  ep.APPLICATION_DATE,
  ep.DESTINATION_COMPANY_NAME,
  ep.TRANSPORT_NAME,
  ep.ESTIMATED_SHIPPING_DATE,
  ep.RECEIVED_DATE,
  ep.EXPORT_PERMIT_ISSUE_DATE,
  ep.EXPIRY_DATE,
  ep.EXPORT_PERMIT_STATUS_CODE,
  ep.ORG_UNIT_NO,
  ou.ORG_UNIT_NAME
FROM
  EXPORT_PERMIT_DETAIL ep
LEFT JOIN ORG_UNIT ou ON (ep.ORG_UNIT_NO = ou.ORG_UNIT_NO)
WHERE ep.EXPORT_PERMIT_STATUS_CODE IN ('ACT')
  AND ep.EXPORT_PERMIT_ISSUE_DATE IS NULL
  AND ep.APPLICATION_DATE >= TRUNC(SYSDATE) - 365 -- Include records with application date within the last YEAR
