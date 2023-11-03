--FTA Starter query on BCGW
--F= Fact
--D = Dimension
--The query allows enough granularity to calculate measures such as application and permit counts by date, while allowing roll up by dimensions such as app purpose, status. type, org unit and location
SELECT TA.TENURE_APP_ID, --F
       TA.TENURE_APPNAME, --F
       TA.TENURE_APPLICATION_STATE_CODE, --F
       tas.DESCRIPTION as TENURE_APPLICATION_STATE_desc, --D
       TA.TENURE_APPLICATION_TYPE_CODE, --F
       TAC.DESCRIPTION TENURE_APPLICATION_TYPE_DESC, --D
       TA.TENURE_APP_PURP_CODE,  --F
       pc.DESCRIPTION as app_purpose_desc,  --D
       TA.ORG_UNIT_NO, --F
       ou.ORG_UNIT_CODE,  --D
       ou.ORG_UNIT_NAME,--D
       TA.SUBMISSION_ID, --F
       TA.FOREST_FILE_ID, --F
       fcl.CUTTING_PERMIT_ID, --FF
       TA.CLIENT_NUMBER, --F
       fcl.FILE_CLIENT_TYPE FILE_CLIENT_TYPE_cd, -- D
       fct.DESCRIPTION as FILE_CLIENT_TYPE_desc, -- D
       fcl.LICENSEE_START_DT, -- D
       fcl.LICENSEE_END_DATE,  --D 
       fcl.CUT_BLOCK_ID, -- why is there only one cut block id --FF
       TA.CLIENT_LOCN_CODE, --F
       TA.CASCADE_SPLIT_CODE, 
       TA.ADJUDICATION_IND, --F
       TA.ADJUDICATED_BY,
       TA.ADJUDICATION_DATE,
       TA.DESCRIPTION, --F
       TA.ADJUDICATION_REQUESTED_IND,
       TA.CURRENT_ASSIGNED_TO,
       ta.COMPLETION_DATE, --F
       ta.SUBMISSION_DATE, --F
       rp.INITIAL_ROAD_LNGTH, --D
       rp.CURRENT_ROAD_LNGTH, --D
       tt.TENURE_TERM, --FF
       tt.LEGAL_EFFECTIVE_DT as tt_LEGAL_EFFECTIVE_DT,
       tt.INITIAL_EXPIRY_DT tt_INITIAL_EXPIRY_DT,
       tm.TIMBER_MARK, --FF
       cbp.CUT_BLOCK_DESCRIPTION, --FF
       cbp.ADMIN_DISTRICT_CODE, --FF/D
       cbp.ADMIN_DISTRICT_NAME,
       cbp.FEATURE_AREA,
       cbp.GEOGRAPHIC_DISTRICT_CODE, 
       cbp.GEOGRAPHIC_DISTRICT_NAME,
       cbp.GEOMETRY
FROM WHSE_FOREST_TENURE.FTEN_TENURE_APPLICATION ta
 left join WHSE_FOREST_TENURE.FTEN_TENURE_APPLICAT_STATE_CD tas on (tas.TENURE_APPLICATION_STATE_CODE = ta.TENURE_APPLICATION_STATE_CODE)
 LEFT JOIN WHSE_FOREST_TENURE.FTEN_TENURE_APPLICAT_TYPE_CD tac ON (ta.TENURE_APPLICATION_TYPE_CODE = tac.TENURE_APPLICATION_TYPE_CODE)
 left join WHSE_FOREST_TENURE.FTEN_TENURE_APPLICAT_PURP_CD pc on (pc.TENURE_APPLICATION_PURP_CODE = ta.TENURE_APP_PURP_CODE) 
 left join WHSE_FOREST_TENURE.FTEN_FOR_CLIENT_LINK fcl on (fcl.FOREST_FILE_ID = ta.FOREST_FILE_ID and fcl.CLIENT_NUMBER = ta.CLIENT_NUMBER) --permit id date?
 left join WHSE_FOREST_TENURE.FTEN_FILE_CLIENT_TYPE_CODE fct on (fcl.FILE_CLIENT_TYPE = fct.FILE_CLIENT_TYPE_CODE)
 left join WHSE_FOREST_TENURE.FTEN_ROAD_PERMIT rp on (rp.FOREST_FILE_ID = ta.FOREST_FILE_ID)
 left join WHSE_FOREST_TENURE.FTEN_TENURE_TERM tt on (tt.FOREST_FILE_ID = ta.FOREST_FILE_ID)
 left join WHSE_FOREST_TENURE.FTEN_TIMBER_MARK tm on (tm.CUTTING_PERMIT_ID = fcl.CUTTING_PERMIT_ID and tm.FOREST_FILE_ID = ta.FOREST_FILE_ID)
 left join WHSE_CORP.ORG_UNIT ou on (ou.ORG_UNIT_NO = ta.ORG_UNIT_NO )
 left join WHSE_FOREST_TENURE.FTEN_CUT_BLOCK_POLY_SVW cbp on (cbp.CUT_BLOCK_FOREST_FILE_ID = ta.FOREST_FILE_ID and cbp.cut_block_id  = fcl.CUT_BLOCK_ID)
--where ta.TENURE_APP_ID = '322283'
--where ta.TENURE_APP_ID='29109'
--where ta.FOREST_FILE_ID ='A18700'
--where ta.FOREST_FILE_ID ='A15385'
--and ta.SUBMISSION_DATE >=to_date('2020-01-01', 'YYYY-MM-DD')
--and ROWNUM < 200
;


---FTA Starter query on Postgres ODS
--FTA Starter query
--F= Fact
--D = Dimension
--The query allows enough granularity to calculate measures such as application and permit counts by date, while allowing roll up by dimensions such as app purpose, status. type, org unit and location
Select 
----Tenure Application
  TA.TENURE_APP_ID --F
  ,TA.TENURE_APPNAME --F
  ,TA.TENURE_APPLICATION_STATE_CODE --F
  ,tas.DESCRIPTION as TENURE_APPLICATION_STATE_desc --D
  ,TA.TENURE_APPLICATION_TYPE_CODE --F
  ,TAC.DESCRIPTION TENURE_APPLICATION_TYPE_DESC --D
  ,TA.TENURE_APP_PURP_CODE  --F
  ,pc.DESCRIPTION as app_purpose_desc  --D
  ,TA.ORG_UNIT_NO --F
  ,ou.ORG_UNIT_CODE  --D
  ,ou.ORG_UNIT_NAME--D
  ,TA.SUBMISSION_ID --F
  ,TA.FOREST_FILE_ID --F
  ,Ta.decision_date
  ,ta.issuance_date
  ,ta.CUTTING_PERMIT_ID --FF
  ,TA.CLIENT_NUMBER --F
  ,fcl.forest_file_client_type_code -- D
  ,fct.DESCRIPTION as FILE_CLIENT_TYPE_desc -- D
  --,ta.CUT_BLOCK_ID -- why is there only one cut block id --FF
  ,TA.CLIENT_LOCN_CODE --F
  ,TA.DESCRIPTION --F
  ,ta.COMPLETION_DATE --F
  ,ta.SUBMISSION_DATE --F
----TENURE Term
  ,tt.TENURE_TERM --FF
  ,tt.LEGAL_EFFECTIVE_DT as tt_LEGAL_EFFECTIVE_DT
  ,tt.INITIAL_EXPIRY_DT as tt_INITIAL_EXPIRY_Dt
  ,tt.CURRENT_EXPIRY_DT
  ,tt.TENURE_EXTEND_CNT
  ,tt.TENR_EXTEND_RSN_ST
---- Prov_Forest_Use
  ,pf.FILE_TYPE_CODE
  ,pf.FOREST_FILE_ID
  ,pf.FILE_TYPE_CODE
  ,pf.FILE_STATUS_ST
  ,pf.FILE_STATUS_DATE
  ,pf.FOREST_REGION
  ,pf.MGMT_UNIT_TYPE
  ,pf.MGMT_UNIT_ID
  ,pf.BCTS_ORG_UNIT
  ,COALESCE(pf.sb_funded_ind,'N') SB_FUNDED_IND
---- Harvesting Authority
  ,hva.CUTTING_PERMIT_ID
  ,hhx.TIMBER_MARK
  ,hva.HARVESTING_AUTHORITY_ID
  ,hva.HARVEST_AUTH_STATUS_CODE
  ,hva.HARVEST_TYPE_CODE
  ,hva.SALVAGE_TYPE_CODE
  ,hva.ISSUE_DATE
  ,hva.EXPIRY_DATE
  ,hva.EXTEND_DATE
  ,coalesce(hva.EXTEND_DATE,hva.EXPIRY_DATE)
  ,hva.CASCADE_SPLIT_CODE
  ,hva.QUOTA_TYPE_CODE
  ,hva.DECIDUOUS_IND
  ,hva.CATASTROPHIC_IND
  ,hva.CROWN_GRANTED_IND
  ,hva.CRUISE_BASED_IND
  ,hva.TENURE_TERM
  ,hva.BCAA_FOLIO_NUMBER
  ,hva.DISTRICT_ADMN_ZONE
  ,hva.STATUS_DATE
  ,hva.HARVEST_AUTH_EXTEND_REAS_CODE
  ,hva.EXTEND_COUNT
  ,haul.MARKING_INSTRUMENT_CODE
  ,haul.MARKING_METHOD_CODE
  ,hva.HARVEST_AREA
  ,hva.LOCATION
  ,hva.MGMT_UNIT_ID
  ,hva.MGMT_UNIT_TYPE_CODE
  ,hva.RETIREMENT_DATE
  ,hva.CROWN_LANDS_REGION_CODE
  ,hva.GEOGRAPHIC_DISTRICT
  ,hva.HIGHER_LEVEL_PLAN_REFERENCE
  ,hva.LICENCE_TO_CUT_CODE
  ,hhx.PRIMARY_MARK_IND
  ,hva.HVA_SKEY
---- Timber Tenure
  ,ttn.REPLACED_DATE
  ,ttn.LICENCE_REPLACEABLE_IND
-- ,tm.TIMBER_MARK --FF
 --count(*)
from FTA_Replication.TENURE_APPLICATION ta 
  left join FTA_Replication.tenure_application_state_code tas on (tas.TENURE_APPLICATION_STATE_CODE = ta.TENURE_APPLICATION_STATE_CODE)
  LEFT JOIN FTA_Replication.tenure_application_type_code tac  ON (ta.TENURE_APPLICATION_TYPE_CODE = tac.TENURE_APPLICATION_TYPE_CODE)
  left join FTA_Replication.tenure_application_purp_code pc   on (pc.TENURE_APPLICATION_PURP_CODE = ta.TENURE_APP_PURP_CODE) --266119
  left join fta_replication.harvesting_authority hva          on (hva.cutting_permit_id = ta.cutting_permit_id and hva.forest_file_id = ta.forest_file_id) --266119
  left join FTA_Replication.TENURE_TERM tt                    on (tt.FOREST_FILE_ID = ta.FOREST_FILE_ID) -- 266119
  left join FTA_Replication.ORG_UNIT ou                       on (ou.ORG_UNIT_NO = ta.ORG_UNIT_NO )
  left join fta_replication.prov_forest_use pf                on (pf.forest_file_id = hva.forest_file_id) --266119
  left join fta_replication.harvesting_hauling_xref hhx       on (hva.HVA_SKEY = hhx.HVA_SKEY and hhx.PRIMARY_MARK_IND = 'Y') --266119
  left join fta_replication.HAULING_AUTHORITY haul            on (haul.timber_mark = hhx.timber_mark )--266119
  left join fta_replication.TIMBER_TENURE ttn                 on (hva.FOREST_FILE_ID = ttn.FOREST_FILE_ID)--266119
  left join fta_replication.HARVEST_SALE hvs                  on (hva.FOREST_FILE_ID = hvs.FOREST_FILE_ID)--266119
  left join (Select *
        , row_number() over(partition by forest_file_id,client_number,client_locn_code order by licensee_start_date desc, licensee_end_date desc ) rn
         from fta_replication.forest_file_client  ) fcl 
          on (fcl.forest_file_id = ta.forest_file_id and fcl.client_number = ta.client_number and fcl.client_locn_code = ta.client_locn_code and fcl.rn =1)
   left join FTA_Replication.FILE_CLIENT_TYPE_CODE fct        on (fcl.forest_file_client_type_code = fct.file_client_type_code)
   --   left join FTA_Replication.TIMBER_MARK tm on (tm.CUTTING_PERMIT_ID = fcl.CUTTING_PERMIT_ID and tm.FOREST_FILE_ID = ta.FOREST_FILE_ID)
   --   left join FTA_Replication.CUT_BLOCK_POLY_SVW cbp on (cbp.CUT_BLOCK_FOREST_FILE_ID = ta.FOREST_FILE_ID and cbp.cut_block_id  = fcl.CUT_BLOCK_ID)

limit 100
;