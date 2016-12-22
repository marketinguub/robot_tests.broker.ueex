*** Settings ***
Library   Selenium2Screenshots
Library   String
Library   DateTime
Library   Selenium2Library
Library   Collections
Library   ueex_service.py

*** Variables ***
${locator.edit.description}                                     id=ePosition_description
${locator.title}                                                id=tePosition_title
${locator.description}                                          id=tePosition_description
${locator.minimalStep.amount}                                   id=tePosition_minimalStep_amount
${locator.value.amount}                                         id=tePosition_value_amount
${locator.value.valueAddedTaxIncluded}                          id=cbPosition_value_valueAddedTaxIncluded
${locator.value.currency}                                       id=tslPosition_value_currency

${locator.auctionPeriod.startDate}                              id=tdtpPosition_auctionPeriod_startDate_Date

${locator.enquiryPeriod.startDate}                              id=tdtpPosition_enquiryPeriod_startDate_Date
${locator.enquiryPeriod.endDate}                                id=tdtpPosition_enquiryPeriod_endDate_Date
${locator.tenderPeriod.startDate}                               id=tdtpPosition_tenderPeriod_startDate_Date
${locator.tenderPeriod.endDate}                                 id=tdtpPosition_tenderPeriod_endDate_Date
${locator.tenderId}                                             id=tPosition_tenderID
${locator.procuringEntity.name}                                 id=tew_Org_0_PE_name
${locator.dgf}                                                  id=tePosition_dgfID
${locator.dgfDecisionID}                                        id=tPosition_dgfDecisionID
${locator.dgfDecisionDate}                                      id=tPosition_dgfDecisionDate
${locator.eligibilityCriteria}                                  id=tPosition_eligibilityCriteria
${locator.tenderAttempts}                                       id=tPosition_tenderAttempts

${locator.procurementMethodType}                                id=tPosition_procurementMethodType

${locator.items[0].quantity}                                    id=tew_item_0_quantity
${locator.items[0].description}                                 id=tew_item_0_description
${locator.items[0].unit.code}                                   id=tw_item_0_unit_code
${locator.items[0].unit.name}                                   id=tslw_item_0_unit_code
${locator.items[0].deliveryAddress.postalCode}                  id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.countryName}                 id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.region}                      id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.locality}                    id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.streetAddress}               id=tw_item_0_Address_short
${locator.items[0].deliveryDate.endDate}                        id=tdtpw_item_0_deliveryDate_endDate_Date
${locator.items[0].classification.scheme}                       id=tw_item_0_classification_description
${locator.items[0].classification.id}                           id=tew_item_0_classification_id
${locator.items[0].classification.description}                  id=tw_item_0_classification_description
${locator.items[0].additionalClassifications[0].scheme}         id=tw_item_0_additionalClassifications_description 
${locator.items[0].additionalClassifications[0].id}             id=tew_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications[0].description}    id=tw_item_0_additionalClassifications_description

${locator.items[1].description}                                 id=tew_item_1_description
${locator.items[1].classification.id}                           id=tew_item_1_classification_id
${locator.items[1].classification.description}                  id=tw_item_1_classification_description
${locator.items[1].classification.scheme}                       id=tw_item_1_classification_description
${locator.items[1].unit.code}                                   id=tw_item_1_unit_code
${locator.items[1].unit.name}                                   id=tslw_item_1_unit_code
${locator.items[1].quantity}                                    id=tew_item_1_quantity

${locator.items[2].description}                                 id=tew_item_2_description
${locator.items[2].classification.id}                           id=tew_item_2_classification_id
${locator.items[2].classification.description}                  id=tw_item_2_classification_description
${locator.items[2].classification.scheme}                       id=tw_item_2_classification_description
${locator.items[2].unit.code}                                   id=tw_item_2_unit_code
${locator.items[2].unit.name}                                   id=tslw_item_2_unit_code
${locator.items[2].quantity}                                    id=tew_item_2_quantity

${locator.questions[0].title}                                   css=.qa_title
${locator.questions[0].description}                             css=.qa_description
${locator.questions[0].date}                                    css=.qa_question_date
${locator.questions[0].answer}                                  css=.qa_answer

${locator.cancellations[0].status}                              css=.cancel_status
${locator.cancellations[0].reason}                              css=.cancel_reason
${locator.contracts.status}                                     css=.contract_status



*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]     @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'uub_Viewer'   Login   ${ARGUMENTS[0]}

Підготувати дані для оголошення тендера
  [Arguments]  ${username}   ${tender_data}    ${role_name}
  [Return]  ${tender_data}

Підготувати дані для оголошення тендера користувачем
  [Arguments]   ${username}      ${tender_data}      ${role_name}
  [Documentation]  Відключити створення тендеру в тестовому режимі
  ${tender_data}=     Run keyword if    '${role_name}' == 'viewer' or '${role_name}' == 'tender_owner' or '${role_name}' == 'provider' or '${role_name}' == 'provider1'
  ...       adapt_test_mode   ${tender_data}
  [Return]      ${tender_data}

Login
  [Arguments]  @{ARGUMENTS}
  Input text      id=eLogin          ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Element    id=btnLogin
  Sleep   2

Змінити користувача
  [Arguments]  @{ARGUMENTS}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep   2
  Input text      id=eLogin          ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Element    id=btnLogin
  Sleep   2

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

    Set Global Variable      ${TENDER_INIT_DATA_LIST}         ${ARGUMENTS[1]}

    ${title}=                Get From Dictionary         ${ARGUMENTS[1].data}             title
    ${dgf}=                  Get From Dictionary         ${ARGUMENTS[1].data}             dgfID
    ${dgfDecisionDate}=      convert_ISO_DMY             ${ARGUMENTS[1].data.dgfDecisionDate}                  
    ${dgfDecisionID}=        Get From Dictionary         ${ARGUMENTS[1].data}             dgfDecisionID
    ${tenderAttempts}=       get_tenderAttempts          ${ARGUMENTS[1].data}

    ${description}=          Get From Dictionary         ${ARGUMENTS[1].data}             description
    ${procuringEntity_name}=  Get From Dictionary        ${ARGUMENTS[1].data.procuringEntity}  name
    ${items}=                Get From Dictionary         ${ARGUMENTS[1].data}             items
    ${budget}=               get_budget                  ${ARGUMENTS[1]}
    ${step_rate}=            get_step_rate               ${ARGUMENTS[1]}       
    
    ${currency}=                 Get From Dictionary         ${ARGUMENTS[1].data.value}       currency
    ${valueAddedTaxIncluded}=    Get From Dictionary         ${ARGUMENTS[1].data.value}       valueAddedTaxIncluded

    ${start_day_auction}=        get_tender_dates          ${ARGUMENTS[1]}            StartDate
    ${start_time_auction}=       get_tender_dates          ${ARGUMENTS[1]}            StartTime

    ${item0}=                Get From List               ${items}                         0
    ${descr_lot}=            Get From Dictionary         ${item0}                         description
    ${unit}=                 Get From Dictionary         ${items[0].unit}                 code
    ${cav_id}=               Get From Dictionary         ${items[0].classification}       id
    ${quantity}=             get_quantity                ${items[0]}



    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element     id=btAddTender    20
    Click Element                        id=btAddTender
    Wait Until Page Contains Element     id=ePosition_title       20
    Select From List By Value            id=slPosition_procurementMethodType      ${ARGUMENTS[1].data.procurementMethodType}
    Input text				 id=ew_Org_0_PE_name               ${procuringEntity_name}
    Input text                           id=ePosition_title                ${title}
    Input text                           id=ePosition_description          ${description}
    Input text                           id=ePosition_dgfID                ${dgf}
    Input text                           id=ePosition_dgfDecisionID        ${dgfDecisionID}
    Input text                           id=dtpPosition_dgfDecisionDate    ${dgfDecisionDate}
    Select From List By Value            id=slPosition_tenderAttempts      ${tenderAttempts}

    Input text             id=ePosition_value_amount                       ${budget}
    Click Element          id=lcbPosition_value_valueAddedTaxIncluded

    Input text             id=dtpPosition_auctionPeriod_startDate_Date          ${start_day_auction}
    Input text             id=ePosition_auctionPeriod_startDate_Time          ${start_time_auction}

    input text             id=ePosition_minimalStep_amount                         ${step_rate}

    Click Element          id=lcb_is_quick

    ${items}=              Get From Dictionary            ${ARGUMENTS[1].data}   items
    ${Items_length}=       Get Length                     ${items}
    :FOR   ${index}   IN RANGE   ${Items_length}
    \	    Click Element          id=btn_items_add
    \       Додати предмет    ${items[${index}]}          ${index}


    Click Element      id=btnSend
    Sleep   3
    Wait Until Element Contains  id=ValidateTips      Збереження виконано         10
    Click Element      id=btnPublic
    Wait Until Page Contains      Публікацію виконано         10

    ${tender_id}=     Get Text        id=tPosition_tenderID
    ${TENDER}=        Get Text        id=tPosition_tenderID
    log to console      ${TENDER}
    [return]    ${TENDER}

Додати предмет
  [Arguments]   ${item}   ${index}
    Wait Until Page Contains Element   id=ew_item_${index}_description    
    Input text        id=ew_item_${index}_description                ${item.description}
    Input text        id=ew_item_${index}_quantity                   ${item.quantity}
    Select From List By Value        id=slw_item_${index}_unit_code  ${item.unit.code}
    Input text        id=ew_item_${index}_classification_id          ${item.classification.id}
    Wait Until Page Contains Element     xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
    Click Element     xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)

    Input text        id=ew_item_${index}_deliveryAddress_countryName       ${item.deliveryAddress.countryName}
    Input text        id=ew_item_${index}_deliveryAddress_postalCode        ${item.deliveryAddress.postalCode}
    Input text        id=ew_item_${index}_deliveryAddress_region            ${item.deliveryAddress.region}
    Input text        id=ew_item_${index}_deliveryAddress_locality          ${item.deliveryAddress.locality}
    Input text        id=ew_item_${index}_deliveryAddress_streetAddress     ${item.deliveryAddress.streetAddress}



Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${TENDER}
  ueex.Пошук тендера по ідентифікатору   ${ARGUMENTS[0]}   ${ARGUMENTS[2]}
  Wait Until Page Contains Element  id=btn_documents_add
  CLICK ELEMENT     id=btn_documents_add
  Choose File       xpath=(//*[@id='upload_form']/input[2])   ${ARGUMENTS[1]}
  Sleep   2
  CLICK ELEMENT     id=upload_button
  Reload Page

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
  Sleep  2
  Click Element    id=btFilterNumber
  Wait Until Page Contains Element  id=ew_fv_0_value
  Input Text      id=ew_fv_0_value   ${ARGUMENTS[1]}
  Click Element    id=btnFilter
  Sleep  2
  Wait Until Page Contains Element  id=tw_tr_10_title
  CLICK ELEMENT     id=tw_tr_10_title 
  sleep  2
  Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])

  
Перейти до сторінки запитань
  Wait Until Page Contains Element   id=questions_ref 
  Click Element     id=questions_ref
  Sleep   1

Перейти до сторінки відмін
  Wait Until Page Contains Element   id=cancels_ref 
  Click Element     id=cancels_ref
  Sleep   1
  
Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
  Click Element     id=btn_question
  Sleep   3
  Input text          id=e_title                 ${title}
  Input text          id=e_description           ${description}
  Click Element     id=SendQuestion
  Sleep  3

Скасувати закупівлю
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = tenderUaId
  ...      ${ARGUMENTS[2]} = cancellation_reason
  ...      ${ARGUMENTS[3]} = doc_path
  ...      ${ARGUMENTS[4]} = description
  ueex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
  Wait Until Page Contains Element   id=btnСancel 
  Click Element     id=btnСancel
  Sleep   2
  Input text                         id=e_reason                 ${ARGUMENTS[2]}
  Click Element                      id=SendCancellation
  Sleep  3
    Wait Until Page Contains Element          xpath=(//*[@id='pnList']/div[1]/div[2]/div[1]/div/div/div[2]/div/span)
    CLICK ELEMENT     xpath=(//*[@id='pnList']/div[1]/div[2]/div[1]/div/div/div[2]/div/span)
    Choose File       xpath=(//*[@id='upload_form']/input[2])   ${ARGUMENTS[3]}
    Sleep   2
    Input text                   id=eFile_accessDetails      ${ARGUMENTS[4]}
    CLICK ELEMENT     id=upload_button
    Sleep   2
    Reload Page
    CLICK ELEMENT     xpath=(//*[@id='pnList']/div[1]/div[2]/div[2]/span)

Отримати інформацію про cancellations[0].status
  Перейти до сторінки відмін
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'cancel_status')])
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'cancel_status')])

Отримати інформацію про cancellations[0].reason
  Перейти до сторінки відмін
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'cancel_reason')])
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_title')])

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    ueex.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із предмету
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  ...      ${ARGUMENTS[2]} ==  item_id
  ...      ${ARGUMENTS[3]} ==  field_name
  ${return_value}=  Run Keyword And Return  ueex.Отримати інформацію із тендера  ${username}  ${tender_uaid}  ${field_name}
  [Return]  ${return_value}

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[2]} ==  fieldname
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[2]}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про procurementMethodType
  ${return_value}=   Отримати тест із поля і показати на сторінці   procurementMethodType
  [Return]  ${return_value}

Отримати інформацію про dgfID
  ${return_value}=   Отримати тест із поля і показати на сторінці   dgf
  [Return]  ${return_value}

Отримати інформацію про dgfDecisionID
  ${return_value}=   Отримати тест із поля і показати на сторінці   dgfDecisionID
  [Return]  ${return_value}

Отримати інформацію про dgfDecisionDate
  ${date_value}=   Отримати тест із поля і показати на сторінці   dgfDecisionDate
  ${return_value}=    convert_date    ${date_value}
  [return]  ${return_value}

Отримати інформацію про tenderAttempts
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderAttempts
  [return]  ${return_value}


Отримати інформацію про eligibilityCriteria
  ${return_value}=   Отримати тест із поля і показати на сторінці   eligibilityCriteria
  [Return]  ${return_value}

Отримати інформацію про status
  Reload Page
  Sleep   5
  ${return_value}=   Get Text   id=tPosition_status
  [return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}


Отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=   convert to number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]   ${return_value}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   5
  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
  Click Element      id=btnPublic
  Wait Until Page Contains      Публікацію виконано        5
  ${result_field}=  Get Value   ${locator.edit.${ARGUMENTS[2]}}
  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}


Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=    Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  [return]  ${return_value}

Отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  [return]   ${return_value}
Отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  [return]  CAV

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  [return]  ${return_value}

Отримати інформацію про items[1].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[1].quantity
  ${return_value}=    Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про items[1].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[1].unit.code
  [return]  ${return_value}

Отримати інформацію про items[1].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[1].unit.name
  [return]   ${return_value}

Отримати інформацію про items[1].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[1].description
  [return]  ${return_value}

Отримати інформацію про items[1].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[1].classification.id
  [return]  ${return_value}

Отримати інформацію про items[1].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[1].classification.scheme
  [return]  CAV

Отримати інформацію про items[1].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[1].classification.description
  [return]  ${return_value}


Отримати інформацію про items[2].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[2].quantity
  ${return_value}=    Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про items[2].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[2].unit.code
  [return]  ${return_value}

Отримати інформацію про items[2].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[2].unit.name
  [return]   ${return_value}

Отримати інформацію про items[2].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[2].description
  [return]  ${return_value}

Отримати інформацію про items[2].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[2].classification.id
  [return]  ${return_value}

Отримати інформацію про items[2].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[2].classification.scheme
  [return]  CAV

Отримати інформацію про items[2].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[2].classification.description
  [return]  ${return_value}



Отримати інформацію про value.currency
  ${return_value}=   Get Selected List Value        slPosition_value_currency
  [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   is_checked                     cbPosition_value_valueAddedTaxIncluded
  [return]  ${return_value}

Отримати інформацію про auctionID
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Отримати інформацію про auctionPeriod.startDate
  ${date_value}=   Get Text  tdtpPosition_auctionPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_auctionPeriod_startDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}

Отримати інформацію про auctionPeriod.endDate
  ${date_value}=   Get Text  tdtpPosition_auctionPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_auctionPeriod_startDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}

Отримати інформацію про tenderPeriod.startDate
  ${date_value}=   Get Text  tdtpPosition_tenderPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_tenderPeriod_startDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}
  [return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${date_value}=   Get Text  tPosition_tenderPeriod_endDate_Date
  ${time_value}=   Get Text  tPosition_tenderPeriod_endDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${date_value}=   Get Text  tdtpPosition_enquiryPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_enquiryPeriod_startDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${date_value}=   Get Text  tdtpPosition_enquiryPeriod_endDate_Date
  ${time_value}=   Get Text  tePosition_enquiryPeriod_endDate_Time
  ${return_value}=    convert_date_to_iso    ${date_value}   ${time_value}
  [return]  ${return_value}


Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.countryName
  [return]   ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]   ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.region
  [return]   ${return_value.split(', ')[2]}

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]  ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]   ${return_value.split(', ')[4]}

Отримати інформацію про items[0].deliveryDate.endDate
  ${date_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${return_value}=    convert_date    ${date_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].title
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_title')])[1]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_title')])[1]
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].date
  ${return_value}=   convert_date_time_to_iso    ${return_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}

Отримати інформацію про questions[1].title
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_title')])[2]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_title')])[2]
  [Return]  ${return_value}

Отримати інформацію про questions[1].description
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_description')])[2]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_description')])[2]
  [Return]  ${return_value}

Отримати інформацію про questions[2].title
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_title')])[3]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_title')])[3]
  [Return]  ${return_value}

Отримати інформацію про questions[2].description
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_description')])[3]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_description')])[3]
  [Return]  ${return_value}

Отримати інформацію про questions[3].title
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_title')])[4]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_title')])[4]
  [Return]  ${return_value}

Отримати інформацію про questions[3].description
  Wait Until Page Contains Element    xpath=(//span[contains(@class, 'qa_description')])[4]
  ${return_value}=  Get text          xpath=(//span[contains(@class, 'qa_description')])[4]
  [Return]  ${return_value}

Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data
  ${answer}=     Get From Dictionary  ${ARGUMENTS[3].data}  answer
  Перейти до сторінки запитань
  Wait Until Page Contains Element      css=.bt_addAnswer
  Click Element                         css=.bt_addAnswer:first-child
  Input Text                            id=e_answer        ${answer}
  Click Element                         id=SendAnswer
  sleep   1

Подати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  ${test_bid_data}
    ${amount}=    get_str          ${ARGUMENTS[2].data.value.amount}
    ${is_qualified}=   is_qualified         ${ARGUMENTS[2]}
    ${is_eligible}=    is_eligible          ${ARGUMENTS[2]}
    ueex.Пошук тендера по ідентифікатору  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
    Wait Until Page Contains Element          id=btnBid    5
    Click Element       id=btnBid
    Sleep   3
    Wait Until Page Contains Element          id=eBid_price    5

    Input Text          id=eBid_price         ${amount}
    Run Keyword If    ${is_qualified}   Click Element   id=lcbBid_selfQualified
    Run Keyword If    ${is_eligible}    Click Element   id=lcbBid_selfEligible

    Click Element       id=btn_save
    sleep   3
    Wait Until Page Contains Element          id=btn_public
    Click Element       id=btn_public
    sleep   1
    ${resp}=    Get Value      id=eBid_price
    [return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ueex.Пошук тендера по ідентифікатору  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   3
    Wait Until Page Contains Element   id=btn_delete    5
    Click Element       id=btn_delete

Отримати інформацію із пропозиції
    [Arguments]  ${username}  ${tender_uaid}   ${field}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   3
    ${value}=   Get Value     id=eBid_price
    ${value}=   Convert To Number      ${value}
    [Return]    ${value}

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
    ${amount}=    get_str          ${${ARGUMENTS[3]}}
    ueex.Пошук тендера по ідентифікатору  ${ARGUMENTS[0]}  ${ARGUMENTS[1]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   3
    Wait Until Page Contains Element          id=eBid_price    5
    Input Text              id=eBid_price         ${amount}
    sleep   1
    Click Element       id=btn_public

Завантажити документ в ставку
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   3
    Wait Until Page Contains Element          id=btn_documents_add    5
    CLICK ELEMENT     id=btn_documents_add
    Choose File       xpath=(//*[@id='upload_form']/input[2])   ${ARGUMENTS[1]}
    Sleep   2
    CLICK ELEMENT     id=upload_button
    Reload Page

Змінити документ в ставці
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  bidId
    Reload Page
    Sleep   3
    CLICK ELEMENT     css=.bt_ReUpload:first-child
    Choose File       xpath=(//*[@id='upload_form']/input[2])   ${ARGUMENTS[1]}
    Sleep   2
    CLICK ELEMENT     id=upload_button
    Reload Page

Завантажити фінансову ліцензію
    [Arguments]  ${username}  ${tender_uaid}  ${filepath}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   3
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      financialLicense
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button
    Reload Page

Отримати інформацію про bids
    [Arguments]  @{ARGUMENTS}
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Click Element                       id=bids_ref

Отримати посилання на аукціон для глядача
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Wait Until Page Contains Element   id=aPosition_auctionUrl    5
    Sleep   5
    ${result} =   Get Text  id=aPosition_auctionUrl
    [return]   ${result}

Отримати посилання на аукціон для учасника
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Wait Until Page Contains Element   id=aPosition_auctionUrl    5
    Sleep   5
    ${result}=    Get Text  id=aPosition_auctionUrl
    [return]   ${result}

Завантажити документ в тендер з типом
    [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      ${doc_type}
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button


Завантажити ілюстрацію
    [Arguments]  ${username}  ${tender_uaid}  ${filepath}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      illustration
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button

Додати Virtual Data Room
    [Arguments]  ${username}  ${tender_uaid}  ${vdr_url} 
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      virtualDataRoom
    Input text                   id=eFile_url                ${vdr_url}
    CLICK ELEMENT     id=upload_button

Додати публічний паспорт активу
    [Arguments]  ${username}  ${tender_uaid}  ${vdr_url}  
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      x_dgfPublicAssetCertificate
    Input text                   id=eFile_url                ${vdr_url}
    CLICK ELEMENT     id=upload_button

Додати офлайн документ
    [Arguments]  ${username}  ${tender_uaid}  ${accessDetails}  
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element  id=btn_documents_add
    CLICK ELEMENT                id=btn_documents_add
    Select From List By Value    id=slFile_documentType      x_dgfAssetFamiliarization
    Input text                   id=eFile_accessDetails      ${accessDetails}
    CLICK ELEMENT     id=upload_button

Отримати інформацію із документа
    [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
    ${doc_name}=   Get Text     xpath=(//div[contains(@class, 'file-name') and contains((@class, '${doc_id}')])
    [Return]   ${doc_name}

Відповісти на запитання
    [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${item_id}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Перейти до сторінки запитань
    Wait Until Page Contains Element      xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
    Click Element                         xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
    Input Text                            id=e_answer        ${answer_data.data.answer}
    Click Element                         id=SendAnswer
    sleep   1

Отримати кількість предметів в тендері
    [Arguments]  ${username}  ${tender_uaid} 
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    ${return_value}=    Get Text           id=tPosition_items_count
    ${return_value}=    Convert To Number  ${return_value}
    [return]  ${return_value}


Отримати інформацію із запитання
    [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Перейти до сторінки запитань
    ${return_value}=      Run Keyword If   '${field_name}' == 'title'
    ...     Get Text    id='qa_title_${question_id}'
    ...     ELSE IF  '${field_name}' == 'answer'     Get Text    id= 'qa_answer_${question_id}'
    ...     ELSE    Get Text   id= 'qa_description_${question_id}'
    [Return]  ${return_value}


Задати запитання на тендер
    [Arguments]  ${username}  ${tender_uaid}  ${question}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Задати питання   ${username}    ${tender_uaid}     ${question}

Задати запитання на предмет
    [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element     xpath=(//span[contains(@class, 'bt_item_question') and contains(@class, '${item_id}')])
    Sleep  3
    Input text          id=e_title                 ${question.data.title}
    Input text          id=e_description           ${question.data.description}
    Click Element     id=SendQuestion
    Sleep  3


Додати предмет закупівлі
    [Arguments]  ${username}  ${tender_uaid}  ${item}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    ${index}=  ueex.Отримати кількість предметів в тендері     ${username}   ${tender_uaid}
    ${ItemAddButtonVisible}=    Page Should Contain Element    id=btn_items_add
    Run Keyword If  '${ItemAddButtonVisible}'=='PASS'   Run Keywords
    ...   Додати предмет                ${item}                ${index}
    ...   AND    Click Element                 id=btnPublic
    ...   AND    Wait Until Page Contains      Публікацію виконано    10
  
Видалити предмет закупівлі
    [Arguments]  ${username}  ${tender_uaid}  ${item_id}
    ueex.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    ${ItemAddButtonVisible}=    Page Should Contain Element    id=btn_items_add
    Run Keyword If  '${ItemAddButtonVisible}'=='PASS'   Run Keywords
    ...   Wait Until Page Contains Element   xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})]) 
    ...   AND    Click Element     xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})])
    ...   AND    Click Element      id=btnPublic
    ...   AND    Wait Until Page Contains      Публікацію виконано         10
 
Отримати кількість документів в ставці
    [Arguments]  ${username}  ${tender_uaid}  ${bid_index}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    ${bid_doc_number}=   Get Matching Xpath Count   xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table)
    [Return]  ${bid_doc_number}

Отримати дані із документу пропозиції
    [Arguments]  ${username}  ${tender_uaid}  ${bid_index}  ${document_index}  ${field}
    ${document_index}=        Evaluate    ${document_index } + 1
    ${result}=   Get Text                 xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table[${document_index}]//span[contains(@class, 'documentType')])
    [Return]   ${result}


Скасування рішення кваліфікаційної комісії
    [Arguments]  ${username}  ${tender_uaid}  ${award_num}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])
    Sleep   1
    Click Element                         xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])


Підтвердити постачальника
    [Arguments]  ${username}  ${tender_uaid}  ${award_num}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'award_button')])
    Sleep   1
    Click Element                         xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'award_button')])

Дискваліфікувати постачальника
    [Arguments]  ${username}  ${tender_uaid}  ${award_num}  ${description}
    Input text          xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Reject_description')])                 ${description}
    Click Element       xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Reject_button')])

Завантажити документ рішення кваліфікаційної комісії
    [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${award_num}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element                xpath=(//*[@id='pnAwardList']/div[last()]//div[contains(@class, 'award_docs')]//span[contains(@class, 'add_document')])
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button
    Reload Page

Завантажити протокол аукціону
    [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${award_index}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   1
    Wait Until Page Contains Element          id=btn_documents_add    5
    Sleep   1
    CLICK ELEMENT     id=btn_documents_add
    Select From List By Value    id=slFile_documentType      auctionProtocol
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button


Завантажити угоду до тендера
    [Arguments]  ${username}  ${tender_uaid}  ${contract_num}  ${filepath}
    ueex.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element                xpath=(//*[@id='pnAwardList']/div[last()]//div[contains(@class, 'contract_docs')]//span[contains(@class, 'add_document')])
    Select From List By Value    id=slFile_documentType      contractSigned
    Choose File                  xpath=(//*[@id='upload_form']/input[2])   ${filepath}
    Sleep   2
    CLICK ELEMENT     id=upload_button
    Reload Page

Підтвердити підписання контракту
    [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
    ${file_path}  ${file_title}  ${file_content}=   create_fake_doc
    Sleep    5
    ueex.Завантажити угоду до тендера   ${username}  ${tender_uaid}  1  ${filepath}
    Wait Until Page Contains Element      xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element                xpath=(//*[@id='pnAwardList']/div[last()]//span[contains(@class, 'contract_register')])
