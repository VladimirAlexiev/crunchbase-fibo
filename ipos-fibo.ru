base <https://ontotext.com/crunchbase/resource/>
prefix cb: <https://ontotext.com/crunchbase/ontology/>
prefix fibo-fbc-fct-mkt: <https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/Markets/>
prefix fibo-fbc-fct-ra: <https://spec.edmcouncil.org/fibo/ontology/FBC/FunctionalEntities/RegistrationAuthorities/>
prefix fibo-fbc-fi-fi: <https://spec.edmcouncil.org/fibo/ontology/FBC/FinancialInstruments/FinancialInstruments/>
prefix fibo-fbc-pas-fpas: <https://spec.edmcouncil.org/fibo/ontology/FBC/ProductsAndServices/FinancialProductsAndServices/>
prefix fibo-fnd-acc-cur: <https://spec.edmcouncil.org/fibo/ontology/FND/Accounting/CurrencyAmount/>
prefix fibo-fnd-agr-ctr: <https://spec.edmcouncil.org/fibo/ontology/FND/Agreements/Contracts/>
prefix fibo-fnd-arr-id: <https://spec.edmcouncil.org/fibo/ontology/FND/Arrangements/IdentifiersAndIndices/>
prefix fibo-fnd-dt-fd: <https://spec.edmcouncil.org/fibo/ontology/FND/DatesAndTimes/FinancialDates/>
prefix fibo-fnd-rel-rel: <https://spec.edmcouncil.org/fibo/ontology/FND/Relations/Relations/>
prefix fibo-fnd-utl-alx: <https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/Analytics/>
prefix fibo-ind-mkt-bas: <https://spec.edmcouncil.org/fibo/ontology/IND/MarketIndices/BasketIndices/>
prefix fibo-sec-eq-eq: <https://spec.edmcouncil.org/fibo/ontology/SEC/Equities/EquityInstruments/>
prefix fibo-sec-sec-id: <https://spec.edmcouncil.org/fibo/ontology/SEC/Securities/SecuritiesIdentification/>
prefix fibo-sec-sec-iss: <https://spec.edmcouncil.org/fibo/ontology/SEC/Securities/SecuritiesIssuance/>
prefix fibo-sec-sec-lst: <https://spec.edmcouncil.org/fibo/ontology/SEC/Securities/SecuritiesListings/>
prefix lcc-lr: <https://www.omg.org/spec/LCC/Languages/LanguageRepresentation/>
prefix puml: <http://plantuml.com/ontology#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
delete {graph ?cb_ipos_uuid_URL {?_s_ ?_p_ ?_o_}}
where {
  service <rdf-mapper:ontorefine:PROJECT_ID> {
    bind(?c_uuid as ?uuid)
    bind(iri(concat("cb/ipos/",?uuid)) as ?cb_ipos_uuid_URL)
    bind(?c_updated_at as ?updated_at)
  }
  <cb> cb:updatedAt ?UPDATED_AT_DT bind(replace(str(?UPDATED_AT_DT),'T',' ') as ?UPDATED_AT) filter(?updated_at > ?UPDATED_AT)
  graph ?cb_ipos_uuid_URL {?_s_ ?_p_ ?_o_}};
insert {graph ?cb_ipos_uuid_URL {
  ## Issuer, Stock exchange
  ?cb_agent_org_uuid_issuer_URL a fibo-fbc-fi-fi:Issuer, fibo-fbc-pas-fpas:Offeror;
    fibo-fnd-rel-rel:issues ?cb_ipo_uuid_share_URL;
    fibo-fnd-rel-rel:hasIdentity ?cb_agent_org_uuid_URL.
  ?cb_exchange_stock_exchange_symbol_URL a fibo-fbc-fct-mkt:Exchange, fibo-fbc-fct-ra:RegistrationAuthority;
    rdfs:label "Exchange ?stock_exchange_symbol";
    fibo-fbc-fct-mkt:hasExchangeAcronym ?stock_exchange_symbol;
    lcc-lr:isIdentifiedBy ?cb_exchange_stock_exchange_symbol_code_URL.
  ?cb_exchange_stock_exchange_symbol_code_URL a lcc-lr:Identifier;
    rdfs:label "Identifier of exchange ?stock_exchange_symbol";
    lcc-lr:hasTag ?stock_exchange_symbol;
    lcc-lr:identifies ?cb_exchange_stock_exchange_symbol_URL;
    lcc-lr:isMemberOf <cb/exchange/code>.
  <cb/exchange/code> a lcc-lr:CodeSet;
    rdfs:label 'CrunchBase exchange code scheme'.
  ?cb_ipo_uuid_share_URL a fibo-sec-sec-lst:ListedSecurity, fibo-sec-eq-eq:Share.
  ## Offering, Share, Listing, Ticker
  ?cb_ipo_uuid_offering_URL a fibo-sec-sec-iss:PublicOffering;
    rdfs:label "IPO (permalink)";
    fibo-fbc-pas-fpas:hasOfferingPrice ?cb_ipo_uuid_price_money_raised_currency_code_URL, ?cb_ipo_uuid_price_USD_URL;
    fibo-fnd-rel-rel:appliesTo ?cb_ipo_uuid_share_URL;
    fibo-fnd-rel-rel:isIssuedBy ?cb_agent_org_uuid_issuer_URL;
    fibo-sec-sec-iss:hasFirstTradeDate ?went_public_on_xsd_date;
    fibo-sec-sec-iss:isRegisteredWith ?cb_exchange_stock_exchange_symbol_URL;
    cb:uuid ?uuid;
    cb:name ?name;
    cb:permalink ?permalink;
    cb:url ?cb_url_xsd_anyURI;
    cb:rank ?rank_xsd_integer;
    cb:createdAt ?created_at_FIXDATE_xsd_dateTime;
    cb:updatedAt ?updated_at_FIXDATE_xsd_dateTime.
  ?cb_ipo_uuid_share_URL a fibo-sec-sec-lst:ListedSecurity, fibo-sec-eq-eq:Share;
    rdfs:label "Share/listed security ?stock_symbol";
    fibo-sec-sec-lst:isListedVia ?cb_ipo_uuid_listing_URL;
    fibo-fnd-agr-ctr:hasPrincipalParty ?cb_agent_org_uuid_issuer_URL;
    fibo-fnd-rel-rel:isIssuedBy ?cb_agent_org_uuid_issuer_URL;
    fibo-fbc-fi-fi:isDenominatedIn ?cb_currency_share_price_currency_code_URL;
    fibo-sec-sec-lst:hasOriginalPlaceOfListing ?cb_exchange_stock_exchange_symbol_URL; ## don't know this but it's mandatory
    fibo-sec-sec-lst:hasHomeExchange ?cb_exchange_stock_exchange_symbol_URL.
  ?cb_ipo_uuid_listing_URL a fibo-sec-sec-lst:Listing;
    rdfs:label "Listing of share/security ?stock_symbol on exchange ?stock_exchange_symbol";
    fibo-sec-sec-lst:lists ?cb_ipo_uuid_share_URL;
    lcc-lr:isIdentifiedBy ?cb_ipo_uuid_ticker_URL;
    fibo-sec-sec-lst:isTradedOn ?cb_exchange_stock_exchange_symbol_URL;
    fibo-fnd-acc-cur:hasCurrency ?cb_currency_share_price_currency_code_URL.
  ?cb_ipo_uuid_ticker_URL a fibo-sec-sec-id:TickerSymbol, fibo-sec-sec-id:ListedSecurityIdentifier;
    rdfs:label "Ticker symbol/security identifier '(stock_exchange_symbol):(stock_symbol)'";
    lcc-lr:hasTag ?stock_symbol;
    fibo-fbc-fct-ra:isRegisteredBy ?cb_exchange_stock_exchange_symbol_URL;
    lcc-lr:identifies ?cb_ipo_uuid_listing_URL;
    fibo-fnd-arr-id:hasInitialAssignmentDate ?went_public_on_xsd_date.
  <cb/currency/USD> a fibo-fnd-acc-cur:Currency.
  ?cb_currency_share_price_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ?cb_currency_valuation_price_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ?cb_currency_money_raised_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ## Financials
  ?cb_ipo_uuid_offering_URL a fibo-sec-sec-iss:PublicOffering;
    fibo-fbc-pas-fpas:hasOfferingPrice ?cb_ipo_uuid_price_money_raised_currency_code_URL, ?cb_ipo_uuid_price_USD_URL.
  ?cb_ipo_uuid_price_money_raised_currency_code_URL a fibo-fnd-acc-cur:MonetaryPrice;
    rdfs:label "Total price/money raised of IPO (permalink) in local currency";
    fibo-fnd-acc-cur:hasAmount ?money_raised_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency ?cb_currency_money_raised_currency_code_URL.
  ?cb_ipo_uuid_price_USD_URL a fibo-fnd-acc-cur:MonetaryPrice;
    rdfs:label "Total price/money raised of IPO (permalink) in USD";
    fibo-fnd-acc-cur:hasAmount ?money_raised_usd_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency <cb/currency/USD>.
  ?cb_ipo_uuid_marketCap_valuation_price_currency_code_URL a fibo-ind-mkt-bas:MarketCapitalization;
    rdfs:label "Market Cap (valuation) at the time of IPO (permalink) in local currency";
    fibo-ind-mkt-bas:hasMarketCapitalizationValue ?cb_ipo_uuid_marketCapValue_valuation_price_currency_code_URL;
    fibo-fnd-utl-alx:hasArgument ?cb_ipo_uuid_pricePerShare_share_price_currency_code_URL;
    fibo-fnd-dt-fd:hasObservedDateTime ?went_public_on_xsd_date;
    fibo-fnd-rel-rel:appliesTo ?cb_agent_org_uuid_issuer_URL.
  ?cb_ipo_uuid_marketCap_USD_URL a fibo-ind-mkt-bas:MarketCapitalization;
    rdfs:label "Market Cap (valuation) at the time of IPO (permalink) in USD";
    fibo-ind-mkt-bas:hasMarketCapitalizationValue ?cb_ipo_uuid_marketCapValue_USD_URL;
    fibo-fnd-utl-alx:hasArgument ?cb_ipo_uuid_pricePerShare_USD_URL;
    fibo-fnd-dt-fd:hasObservedDateTime ?went_public_on_xsd_date;
    fibo-fnd-rel-rel:appliesTo ?cb_agent_org_uuid_issuer_URL.
  ?cb_ipo_uuid_marketCapValue_valuation_price_currency_code_URL a fibo-fnd-acc-cur:MonetaryAmount;
    rdfs:label "Monetary amount of Market Cap (valuation) in local currency";
    fibo-fnd-acc-cur:hasAmount ?valuation_price_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency ?cb_currency_valuation_price_currency_code_URL.
  ?cb_ipo_uuid_marketCapValue_USD_URL a fibo-fnd-acc-cur:MonetaryAmount;
    rdfs:label "Monetary amount of Market Cap (valuation) in USD";
    fibo-fnd-acc-cur:hasAmount ?valuation_price_usd_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency <cb/currency/USD>.
  ?cb_ipo_uuid_pricePerShare_share_price_currency_code_URL a fibo-sec-eq-eq:PricePerShare;
    rdfs:label "Price per share at the time of IPO (permalink) in local currency";
    fibo-fnd-acc-cur:hasAmount ?share_price_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency ?cb_currency_share_price_currency_code_URL;
    fibo-fnd-dt-fd:hasObservedDateTime ?went_public_on_xsd_date;
    fibo-fnd-acc-cur:isPriceFor ?cb_ipo_uuid_share_URL.
  ?cb_ipo_uuid_pricePerShare_USD_URL a fibo-sec-eq-eq:PricePerShare;
    rdfs:label "Price per share at the time of IPO (permalink) in USD";
    fibo-fnd-acc-cur:hasAmount ?share_price_usd_xsd_decimal;
    fibo-fnd-acc-cur:hasCurrency <cb/currency/USD>;
    fibo-fnd-dt-fd:hasObservedDateTime ?went_public_on_xsd_date;
    fibo-fnd-acc-cur:isPriceFor ?cb_ipo_uuid_share_URL.
  <cb/currency/USD> a fibo-fnd-acc-cur:Currency.
  ?cb_currency_share_price_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ?cb_currency_valuation_price_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ?cb_currency_money_raised_currency_code_URL a fibo-fnd-acc-cur:Currency.
  ?cb_ipo_uuid_share_URL a fibo-sec-sec-lst:ListedSecurity, fibo-sec-eq-eq:Share.
  ?cb_agent_org_uuid_issuer_URL a fibo-fbc-fi-fi:Issuer, fibo-fbc-pas-fpas:Offeror.
  ## Currencies: USD plus 3 more for the 3 financials
  <cb/currency/USD> a fibo-fnd-acc-cur:Currency;
    lcc-lr:hasName 'USD';
    rdfs:label 'Currency USD'.
  <cb/currency/USD/code> a fibo-fnd-acc-cur:CurrencyIdentifier;
    rdfs:label 'Code of currency USD';
    lcc-lr:hasTag 'USD';
    lcc-lr:denotes <cb/currency/USD>;
    lcc-lr:identifies <cb/currency/USD>;
    lcc-lr:isMemberOf <cb/currency>.
  ?cb_currency_share_price_currency_code_URL a fibo-fnd-acc-cur:Currency;
    lcc-lr:hasName ?share_price_currency_code;
    rdfs:label 'Currency (share_price_currency_code)'.
  ?cb_currency_share_price_currency_code_code_URL a fibo-fnd-acc-cur:CurrencyIdentifier;
    rdfs:label 'Code of currency (share_price_currency_code)';
    lcc-lr:hasTag ?share_price_currency_code;
    lcc-lr:denotes ?cb_currency_share_price_currency_code_URL;
    lcc-lr:identifies ?cb_currency_share_price_currency_code_URL;
    lcc-lr:isMemberOf <cb/currency>.
  ?cb_currency_valuation_price_currency_code_URL a fibo-fnd-acc-cur:Currency;
    lcc-lr:hasName ?valuation_price_currency_code;
    rdfs:label 'Currency (valuation_price_currency_code)'.
  ?cb_currency_valuation_price_currency_code_code_URL a fibo-fnd-acc-cur:CurrencyIdentifier;
    rdfs:label 'Code of currency (valuation_price_currency_code)';
    lcc-lr:hasTag ?valuation_price_currency_code;
    lcc-lr:denotes ?cb_currency_valuation_price_currency_code_URL;
    lcc-lr:identifies ?cb_currency_valuation_price_currency_code_URL;
    lcc-lr:isMemberOf <cb/currency>.
  ?cb_currency_money_raised_currency_code_URL a fibo-fnd-acc-cur:Currency;
    lcc-lr:hasName ?money_raised_currency_code;
    rdfs:label 'Currency (money_raised_currency_code)'.
  ?cb_currency_money_raised_currency_code_code_URL a fibo-fnd-acc-cur:CurrencyIdentifier;
    rdfs:label 'Code of currency (money_raised_currency_code)';
    lcc-lr:hasTag ?money_raised_currency_code;
    lcc-lr:denotes ?cb_currency_money_raised_currency_code_URL;
    lcc-lr:identifies ?cb_currency_money_raised_currency_code_URL;
    lcc-lr:isMemberOf <cb/currency>.
  <cb/currency> a lcc-lr:IdentificationScheme, lcc-lr:CodeSet;
    rdfs:label 'CrunchBase currency code set';
    skos:definition 'Currency identifiers used in CrunchBase';
    skos:scopeNote 'Better reconcile to fibo-fnd-acc-4217:ISO4217-CodeSet'.
}}
where {
  service <rdf-mapper:ontorefine:PROJECT_ID> {
    bind(?c_uuid as ?uuid)
    bind(iri(concat("cb/ipos/",?uuid)) as ?cb_ipos_uuid_URL)
    bind(?c_updated_at as ?updated_at)
    bind(?c_org_uuid as ?org_uuid)
    bind(?c_stock_exchange_symbol as ?stock_exchange_symbol)
    bind(?c_permalink as ?permalink)
    bind(?c_money_raised_currency_code as ?money_raised_currency_code)
    bind(?c_went_public_on as ?went_public_on)
    bind(?c_name as ?name)
    bind(?c_cb_url as ?cb_url)
    bind(?c_rank as ?rank)
    bind(?c_created_at as ?created_at)
    bind(?c_stock_symbol as ?stock_symbol)
    bind(?c_share_price_currency_code as ?share_price_currency_code)
    bind(?c_valuation_price_currency_code as ?valuation_price_currency_code)
    bind(?c_money_raised as ?money_raised)
    bind(?c_money_raised_usd as ?money_raised_usd)
    bind(?c_valuation as ?valuation)
    bind(?c_valuation_price as ?valuation_price)
    bind(?c_valuation_price_usd as ?valuation_price_usd)
    bind(?c_share_price as ?share_price)
    bind(?c_share_price_usd as ?share_price_usd)
    bind(iri(concat("cb/agent/",?org_uuid,"/issuer")) as ?cb_agent_org_uuid_issuer_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/share")) as ?cb_ipo_uuid_share_URL)
    bind(iri(concat("cb/agent/",?org_uuid)) as ?cb_agent_org_uuid_URL)
    bind(iri(concat("cb/exchange/",?stock_exchange_symbol)) as ?cb_exchange_stock_exchange_symbol_URL)
    bind(iri(concat("cb/exchange/",?stock_exchange_symbol,"/code")) as ?cb_exchange_stock_exchange_symbol_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/offering")) as ?cb_ipo_uuid_offering_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/price/",?money_raised_currency_code)) as ?cb_ipo_uuid_price_money_raised_currency_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/price/USD")) as ?cb_ipo_uuid_price_USD_URL)
    bind(strdt(?went_public_on,xsd:date) as ?went_public_on_xsd_date)
    bind(strdt(?cb_url,xsd:anyURI) as ?cb_url_xsd_anyURI)
    bind(strdt(?rank,xsd:integer) as ?rank_xsd_integer)
    bind(REPLACE(?created_at,' ','T') as ?created_at_FIXDATE)
    bind(strdt(?created_at_FIXDATE,xsd:dateTime) as ?created_at_FIXDATE_xsd_dateTime)
    bind(REPLACE(?updated_at,' ','T') as ?updated_at_FIXDATE)
    bind(strdt(?updated_at_FIXDATE,xsd:dateTime) as ?updated_at_FIXDATE_xsd_dateTime)
    bind(iri(concat("cb/ipo/",?uuid,"/listing")) as ?cb_ipo_uuid_listing_URL)
    bind(iri(concat("cb/currency/",?share_price_currency_code)) as ?cb_currency_share_price_currency_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/ticker")) as ?cb_ipo_uuid_ticker_URL)
    bind(iri(concat("cb/currency/",?valuation_price_currency_code)) as ?cb_currency_valuation_price_currency_code_URL)
    bind(iri(concat("cb/currency/",?money_raised_currency_code)) as ?cb_currency_money_raised_currency_code_URL)
    bind(strdt(?money_raised,xsd:decimal) as ?money_raised_xsd_decimal)
    bind(strdt(?money_raised_usd,xsd:decimal) as ?money_raised_usd_xsd_decimal)
    bind(iri(concat("cb/ipo/",?uuid,"/marketCap/",?valuation_price_currency_code)) as ?cb_ipo_uuid_marketCap_valuation_price_currency_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/marketCapValue/",?valuation_price_currency_code)) as ?cb_ipo_uuid_marketCapValue_valuation_price_currency_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/pricePerShare/",?share_price_currency_code)) as ?cb_ipo_uuid_pricePerShare_share_price_currency_code_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/marketCap/USD")) as ?cb_ipo_uuid_marketCap_USD_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/marketCapValue/USD")) as ?cb_ipo_uuid_marketCapValue_USD_URL)
    bind(iri(concat("cb/ipo/",?uuid,"/pricePerShare/USD")) as ?cb_ipo_uuid_pricePerShare_USD_URL)
    bind(strdt(?valuation_price,xsd:decimal) as ?valuation_price_xsd_decimal)
    bind(strdt(?valuation_price_usd,xsd:decimal) as ?valuation_price_usd_xsd_decimal)
    bind(strdt(?share_price,xsd:decimal) as ?share_price_xsd_decimal)
    bind(strdt(?share_price_usd,xsd:decimal) as ?share_price_usd_xsd_decimal)
    bind(iri(concat("cb/currency/",?share_price_currency_code,"/code")) as ?cb_currency_share_price_currency_code_code_URL)
    bind(iri(concat("cb/currency/",?valuation_price_currency_code,"/code")) as ?cb_currency_valuation_price_currency_code_code_URL)
    bind(iri(concat("cb/currency/",?money_raised_currency_code,"/code")) as ?cb_currency_money_raised_currency_code_code_URL)
  }
  <cb> cb:updatedAt ?UPDATED_AT_DT bind(replace(str(?UPDATED_AT_DT),'T',' ') as ?UPDATED_AT) filter(?updated_at > ?UPDATED_AT)};
