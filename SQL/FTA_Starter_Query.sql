--FTA Starter query
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