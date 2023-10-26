--Starter query to join all the key tables to be used in reporting application counts
Select * 
from 
(
    Select dt.DISPOSITION_TRANSACTION_SID,
       dt.DISPOSITION_SID,
       dt.PURPOSE_SID,
       ap.PURPOSE_NME,
       dt.SUBPURPOSE_SID,
       asp.SUBPURPOSE_NME,
       dt.SUBTYPE_SID,
       ast.SUBTYPE_NME,
       dt.TYPE_SID,
       avt.TYPE_NME,
       dt.ORG_UNIT_SID,
       ou.UNIT_NAME,
       dt.MANAGING_AGENCY,
       dt.APPLICATION_TYPE_CDE,
       dt.RECEIVED_DAT,
       dt.COMMENCEMENT_DAT,
       dt.EXPIRY_DAT,
       dt.DOCUMENT_CHR,
       dt.ENTERED_DAT,
       dt.LOCATION_DSC,
       dt.OFFER_TIMBER_DEFERMENT_YRN,
       dt.SURFACE_OR_UNDER_CDE,
       dt.TIMBER_VALUE_DLR,
       dp.ACTIVATION_CDE,
       dp.FILE_CHR,
       ds.CODE_CHR_STAGE,
       s.STAGE_NME,
       ds.CODE_CHR_STATUS,
       st.STATUS_NME ,
       ds.EFFECTIVE_DAT status_effective_dt,
       ds.EXPIRY_DAT status_expiry_dt,
       tt.INTERESTED_PARTY_SID,
       tt.LOCATION_SID,
       tt.TENANT_SID,
       ta.ZIP_CODE,
       ta.CITY,
       re.REGION_CDE,
       re.NAME,
    row_number()oveR(partition by dt.DISPOSITION_TRANSACTION_SID order by nvl(ds.EXPIRY_DAT, to_date('2199-01-01','YYYY-MM-DD')) desc) status_rnk_reverse,
	
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null else dt.COMMENCEMENT_DAT - dt.ENTERED_DAT end  as days_btw_entered_2_comcmnt,
    case when to_char(dt.EXPIRY_DAT,'YYYY') = '9999' then null else dt.EXPIRY_DAT - dt.COMMENCEMENT_DAT end as days_btw_comcmnt_2_expiry,
    case when to_char(dt.RECEIVED_DAT, 'YYYY') = '1111' then null else dt.COMMENCEMENT_DAT - dt.RECEIVED_DAT  end as days_btw_recvd_2_comcmnt,
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null 
    when to_char(dt.EXPIRY_DAT,'YYYY') = '9999' then null else dt.EXPIRY_DAT - dt.ENTERED_DAT  end as days_btw_expiry_2_entered,
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null 
        when to_char(dt.RECEIVED_DAT, 'YYYY') = '1111' then null else dt.ENTERED_DAT - dt.RECEIVED_DAT end as days_btw_entered_2_recvd,
        
       1 as dummy

    FROM WHSE_TANTALIS.TA_DISPOSITION_TRANSACTIONS dt -- 458498
     left join WHSE_TANTALIS.TA_DISPOSITIONS dp on (dt.DISPOSITION_SID = dp.DISPOSITION_SID) -- 458498
    left join  WHSE_TANTALIS.TA_DISP_TRANS_STATUSES ds on (ds.DISPOSITION_TRANSACTION_SID = dt.DISPOSITION_TRANSACTION_SID) --497693
    left join WHSE_TANTALIS.TA_STAGES s on (s.CODE_CHR = ds.CODE_CHR_STAGE) --497693
    left join WHSE_TANTALIS.TA_AVAILABLE_TYPES avt on (avt.TYPE_SID = dt.TYPE_SID)--497693
    left join WHSE_TANTALIS.TA_STATUS st on (st.CODE_CHR = ds.CODE_CHR_STATUS)--497693
    left join WHSE_TANTALIS.TA_AVAILABLE_PURPOSES ap on (ap.PURPOSE_SID = dt.PURPOSE_SID)--497693
    left join WHSE_TANTALIS.TA_ORGANIZATION_UNITS ou on (ou.ORG_UNIT_SID = dt.ORG_UNIT_SID)--497693
    left join WHSE_TANTALIS.TA_AVAILABLE_SUBTYPES ast on (ast.SUBTYPE_SID = dt.SUBTYPE_SID and ast.TYPE_SID = dt.TYPE_SID) --497693
    left join WHSE_TANTALIS.TA_TENANTS tt on (tt.DISPOSITION_TRANSACTION_SID = dt.DISPOSITION_TRANSACTION_SID ) --662092
    left join (
    Select row_number()over(partition by ta.INTERESTED_PARTY_SID, ta.LOCATION_SID order by ta.CREATE_DAT desc, ta.ADDRESS_SID desc) rn ,ta.* 
      from WHSE_TANTALIS.TA_ADDRESSES ta) ta on (ta.INTERESTED_PARTY_SID = tt.INTERESTED_PARTY_SID and ta.LOCATION_SID = tt.LOCATION_SID and ta.rn=1 )--662092
    left join WHSE_TANTALIS.TA_REGIONS re on (re.REGION_CDE = ta.REGION_CDE) --662092
    -- /*left join WHSE_TANTALIS.TA_LAND_DISTRICTS ld on (ld.)
    -- left join WHSE_TANTALIS.TA_RESTRICTIONS re on (re.CODE_CHR = ) --not sure the fit*/
    left join WHSE_TANTALIS.TA_AVAILABLE_SUBPURPOSES asp on (asp.PURPOSE_SID = dt.PURPOSE_SID and asp.SUBPURPOSE_SID = dt.SUBPURPOSE_SID) --662092
)
where rownum<200
;



Select max(COMMENCEMENT_DAT) latest_COMMENCEMENT_DAT,
max(days_btw_entered_2_comcmnt) days_btw_entered_2_comcmnt,
max(days_btw_comcmnt_2_expiry) days_btw_comcmnt_2_expiry,
max(days_btw_recvd_2_comcmnt) days_btw_recvd_2_comcmnt,
max(days_btw_expiry_2_entered) days_btw_expiry_2_entered,
max(days_btw_entered_2_recvd) days_btw_entered_2_recvd
from 
(
    Select dt.DISPOSITION_TRANSACTION_SID,
       dt.DISPOSITION_SID,
       dt.PURPOSE_SID,
       ap.PURPOSE_NME,
       dt.SUBPURPOSE_SID,
       asp.SUBPURPOSE_NME,
       dt.SUBTYPE_SID,
       ast.SUBTYPE_NME,
       dt.TYPE_SID,
       avt.TYPE_NME,
       dt.ORG_UNIT_SID,
       ou.UNIT_NAME,
       dt.MANAGING_AGENCY,
       dt.APPLICATION_TYPE_CDE,
       dt.RECEIVED_DAT,
       dt.COMMENCEMENT_DAT,
       dt.EXPIRY_DAT,
       dt.DOCUMENT_CHR,
       dt.ENTERED_DAT,
       dt.LOCATION_DSC,
       dt.OFFER_TIMBER_DEFERMENT_YRN,
       dt.SURFACE_OR_UNDER_CDE,
       dt.TIMBER_VALUE_DLR,
       dp.ACTIVATION_CDE,
       dp.FILE_CHR,
       ds.CODE_CHR_STAGE,
       s.STAGE_NME,
       ds.CODE_CHR_STATUS,
       st.STATUS_NME,
       ds.EFFECTIVE_DAT,
       ds.EXPIRY_DAT,
       st.ACTIVATION_CDE,
       tt.INTERESTED_PARTY_SID,
       tt.LOCATION_SID,
       tt.TENANT_SID,
       ta.ZIP_CODE,
       ta.CITY,
       re.REGION_CDE,
       re.NAME,
       --st.EXPIRY_DAT, 
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null else dt.COMMENCEMENT_DAT - dt.ENTERED_DAT end  as days_btw_entered_2_comcmnt,
    case when to_char(dt.EXPIRY_DAT,'YYYY') = '9999' then null else dt.EXPIRY_DAT - dt.COMMENCEMENT_DAT end as days_btw_comcmnt_2_expiry,
    case when to_char(dt.RECEIVED_DAT, 'YYYY') = '1111' then null else dt.COMMENCEMENT_DAT - dt.RECEIVED_DAT  end as days_btw_recvd_2_comcmnt,
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null 
    when to_char(dt.EXPIRY_DAT,'YYYY') = '9999' then null else dt.EXPIRY_DAT - dt.ENTERED_DAT  end as days_btw_expiry_2_entered,
    case when to_char(dt.ENTERED_DAT, 'YYYY') = '1111' then null 
        when to_char(dt.RECEIVED_DAT, 'YYYY') = '1111' then null else dt.ENTERED_DAT - dt.RECEIVED_DAT end as days_btw_entered_2_recvd,
        
       1 as dummy

    FROM WHSE_TANTALIS.TA_DISPOSITION_TRANSACTIONS dt -- 458498
     left join WHSE_TANTALIS.TA_DISPOSITIONS dp on (dt.DISPOSITION_SID = dp.DISPOSITION_SID) -- 458498
    left join  WHSE_TANTALIS.TA_DISP_TRANS_STATUSES ds on (ds.DISPOSITION_TRANSACTION_SID = dt.DISPOSITION_TRANSACTION_SID) --497693
    left join WHSE_TANTALIS.TA_STAGES s on (s.CODE_CHR = ds.CODE_CHR_STAGE) --497693
    left join WHSE_TANTALIS.TA_AVAILABLE_TYPES avt on (avt.TYPE_SID = dt.TYPE_SID)--497693
    left join WHSE_TANTALIS.TA_STATUS st on (st.CODE_CHR = ds.CODE_CHR_STATUS)--497693
    left join WHSE_TANTALIS.TA_AVAILABLE_PURPOSES ap on (ap.PURPOSE_SID = dt.PURPOSE_SID)--497693
    left join WHSE_TANTALIS.TA_ORGANIZATION_UNITS ou on (ou.ORG_UNIT_SID = dt.ORG_UNIT_SID)--497693
    left join WHSE_TANTALIS.TA_AVAILABLE_SUBTYPES ast on (ast.SUBTYPE_SID = dt.SUBTYPE_SID and ast.TYPE_SID = dt.TYPE_SID) --497693
    left join WHSE_TANTALIS.TA_TENANTS tt on (tt.DISPOSITION_TRANSACTION_SID = dt.DISPOSITION_TRANSACTION_SID ) --662092
    left join (
    Select row_number()over(partition by ta.INTERESTED_PARTY_SID, ta.LOCATION_SID order by ta.CREATE_DAT desc, ta.ADDRESS_SID desc) rn ,ta.* 
      from WHSE_TANTALIS.TA_ADDRESSES ta) ta on (ta.INTERESTED_PARTY_SID = tt.INTERESTED_PARTY_SID and ta.LOCATION_SID = tt.LOCATION_SID and ta.rn=1 )--662092
    left join WHSE_TANTALIS.TA_REGIONS re on (re.REGION_CDE = ta.REGION_CDE) --662092
    -- /*left join WHSE_TANTALIS.TA_LAND_DISTRICTS ld on (ld.)
    -- left join WHSE_TANTALIS.TA_RESTRICTIONS re on (re.CODE_CHR = ) --not sure the fit*/
    left join WHSE_TANTALIS.TA_AVAILABLE_SUBPURPOSES asp on (asp.PURPOSE_SID = dt.PURPOSE_SID and asp.SUBPURPOSE_SID = dt.SUBPURPOSE_SID) --662092
)
where rownum<200
;