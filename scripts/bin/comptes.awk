#!/usr/bin/awk -f

BEGIN{
    # summary only
    #VERBOSE=0
    # only na
    VERBOSE=1
    # full
    #VERBOSE=2
    VERBOSE=1
}

{DO=0}
/^\( +[0-9]+ [0-9]+ .* *[0-9]+ [0-9]+ [0-9]+[\* ]*[0-9, ]*\)/{
    DO=1
}

DO == 1 && /PRLV CREDIT COOPERATIF/{
    desc   = substr($0,11,33)
    day   = substr($0,46,2)
    month = substr($0,49,2)
    year = substr($0,52,2)
}
DO == 1 && !/PRLV CREDIT COOPERATIF/{
    day   = substr($0,45,2)
    month = substr($0,48,2)
    year = substr($0,51,2)
}

DO == 1{
    desc   = substr($0,11,33)
    amount_debit = substr($0,57,24)
    amount_credit= substr($0,76,25)
    gsub(" ","",amount_debit)
    gsub(" ","",amount_credit)
    sub(",",".",amount_debit)
    sub(",",".",amount_credit)
    amount=amount_credit-amount_debit
    cat="na"
    switch (desc) {
        case /ABONNEMENT/:
        case /COTISATION/:  cat="banque"; desc_idx=12; break
        case /CHEQUE/:      cat="chq debit"; desc_idx=11; break
        case /REMISE CHQ/:  cat="chq credit"; desc_idx=12; break
        case /COOPA/:       cat="vir debit"; desc_idx=13; break
        case /VIR/:         cat="vir credit"; desc_idx=5; break
        case /PRELEVEMENT/: cat="prlv"; desc_idx=13; break
        case /COM RET DAB/:
        case /COUPONS/:
        case /VRT RISTOURNE CREDIT COOP/:
        case /PRLV SPB SECURIVAL/:
        case /REGUL/:
        case /COMMISSION INTERVENTION/:
        case /OUVERTURE LVA/:
        case /FRAIS ACHAT/:
        case /FRAIS RETR/:
        case /PRLV ACC INT ENERCOOP/: cat="banque"; desc_idx=1; break
        case /PRLV SEPA/:   cat="prlv"; desc_idx=11; break
        case /RETRAIT DAB/: cat="dab";  desc_idx=13; break
        case /ECH/:         cat="pret"; desc_idx=16; break
        case /FRAIS AVENANT/:
        case /PRLV CREDIT COOPERATIF/: cat="pret"; desc_idx=1; break;
        case /CARTE/:       cat="carte"; carte_id=substr(desc,12,4); desc_idx=17; break
    }
    description=substr(desc,desc_idx)
    sub(" *$","",description)

    # Start ventilation

    vent="na"
    switch (cat) {
        case "na":
            print $0
            break
        case "vir debit":
            switch (description) {
                case /MICHEL/: vent="epargne"; break
                case /Emmanuelle PIOTET/: vent="enfant"; break
                default:vent=cat; break
                }
            break
        case "vir credit":
            switch (description) {
                case /MICHEL/: vent="epargne"; break
                case /PAIERIE/:
                case /Google Payment/:
                case /Intel/: vent="salaire"; break
                default:vent=cat; break
                }
            break
        case "banque":
        case "dab":
        case /chq/:
        case "pret": vent=cat; break
    }
    switch (description) {
        case /Free Mobile/:
        case /Free Telecom/:
        case /Bouygues Telecom/:
        case /NUMERICABLE/:
        case /FREE MOBILE/:
        case /LA POSTE/:    vent="ptt"; break

        case /VILLE TOULOUSE/:
        case /ENFANCE NET/:
        case /BRINDILLE/: vent="enfant"; break;

        case /GOOGLE/:
        case /NATURE DECOUVERT/:
        case /SA H OUGIER/: # Article de fête
        case /NETFLIX/:
        case /GIBERT JOSEPH/:
        case /OMBRES BLANCHES/:
        case /ESPACE MILAN/:
        case /CROQUENOTES/:
        case /LIBRAIRIE/:
        case /PETITS RUISSEAUX/:
        case /BD FUGUE/:
        case /EDITIONS/:
        case /AUTRE RIVE/:
        case /CULTURA/:
        case /DISNEYSTORE/:
        case /RELAY/:
        case /RELAIS/:
        case /PISCINE/:
        case /AMAZON/:
        case /CE INTEL/:
        case /DARTY/:
        case /PhotoboxFR/:
        case /PHOTO/:
        case /CLAIRES TOULOUSE/:
        case /LOLITA/:
        case /SARL A SUIVRE/: # Drogerie place Salingro
        case /PHILDAR/:
        case /MJC ROGUET/:
        case /I RUN STORE/:
        case /ZAPSPORT/:
        case /DECATHLON/:
        case /INTERSPORT/:
        case /SPORT 2000/:
        case /LE PASSE TEMPS/:
        case /CITE L.*ESPACE/:
        case /STARCAB/:
        case /MEYCLUB/:
        case /ATLAS MANDATAIRE/:
        case /RAKUTEN/:
        case /RUE DU COMMERCE/:
        case /NATURE & DEC/:
        case /Amazon/:
        case /STEAM/:
        case /TOULOUSE O CD/:
        case /EAU VIVE/:
        case /TOYS R US/:
        case /BOWLING/:
        case /BLEU CITRON PROD/:
        case /SLG SA/: # kalidea
        case /BONHOMME DE BOIS/:
        case /LE PETIT TOM/: # jouet
        case /LE BEAU MANEGE/:
        case /MUSEE/:
        case /YAKA/: # photo
        case /BILOBA/:
        case /UNI PRESS/:
        case /ABATTOIRS LIVRE/:
        case /LEETCHI/:
        case /KISSKISS/:
        case /GROSBILL/:     vent="loisir"; break;

        case /CINEMA ABC/:
        case /\<CINE\>/:
        case /GAUMONT/:
        case /CIRCA/:
        case /FESTIK/:     vent="sortie"; break;

        case /EMPREINTE/:    vent="soin"; break;
        case /VETERINA/:    vent="chat"; break;

        case "NAFNAF":
        case /ZARA/:
        case /OKAIDI/:
        case /CAMAIEU/:
        case /SALOMON TOULOUSE/:
        case /GAL. LAFAYETTE/:
        case /CHAUSSLAND/:
        case /ESPRIT/:
        case /CHAUSSEA/:
        case /CHAUSSUR/:
        case /JULES/:
        case /CELIO/:
        case /KIABI/:
        case /CARIBOO/:
        case /SARENZA/:
        case /ETHIC ET CHIC/:
        case /SERGENT MAJOR/:
        case /BONOBO/: # jean femme
        case /DPAM/: # du pareil au meme
        case /LA HALLE/:
        case /GEMO/:
        case /AM . VINTAGE/:
        case /DE FIL EN TROC/:
        case /LHCM ANGLET/:
        case /3 SUISSES/:
        case /CAL?ZEDONIA/:
        case /PETIT BATEAU/:
        case /TAM TAM/:
        case /H & M/:       vent="vetement"; break

        case /PIZZA/:
        case /CHEZ MATHIEU/:
        case /BRAISE/:
        case /CHAUDRON/:
        case /HALLES SAVOYARD/:
        case /AUX PETITS FOURS/:
        case /FOLLES SAISONS/:
        case /SUBWAY/:
        case /TRAITEUR/:
        case /PAUL/:
        case /MACARONS ADAM/:
        case /EUGENIE/:
        case /TOMMY/:
        case /CAFE BRANLY/:
        case /COMPTOIR BACCHUS/:
        case /\<RIE\>/:
        case /CONSEIL REGIONAL/:
        case /SODEXO/:
        case /BAR/:
        case /BRASSERI/:
        case /CAFE/:
        case /GEARY STREET/: # place des oliviers
        case /LE KASHMIR/:
        case /LEE IN/:
        case /HAAGEN DAZS/:
        case /MADELEINE/:
        case /BAILLARDRAN/: # Canelés
        case /ENTRACTE/:
        case /PAIN SUR LA PLAN/:
        case /MLE MIRAMAND/: # kebab bezier ?
        case /SARL V & V/:
        case /MA?C ?DO/:
        case /KFC/:
        case /QUICK/:       vent="cantine"; break

        case /SALON/:
        case /ANGELINA/:
        case /DI PASTA/:
        case /GRAND PIZZERIA/:
        case /LA BELLE EQUIPE/:
        case /LE VAUQUELIN/:
        case /AU BUREAU/:
        case /AUBERGE DES CEVE/:
        case "LE PERCHEPINTE":
        case /SPRINGFIELD/:
        case /TABLE/:
        case /RESTAURANT/:
        case /BISTRO/:
        case /LE MADRID/:
        case /COTE A L ARETE/:
        case /RAGAZZI PEPPONE/:
        case /EARL DU TAPAS/:
        case /TANTINA/:
        case /COTE GARONNE/:
        case /DOWN TOWN/:
        case /CHEZ ZOREILLES/: #st cyp
        case /ALBATROS/:
        case /GUINGUETTE/:
        case /CHEZ NAVARRE/:
        case /MARSHALLS DINER/:       vent="resto"; break

        case /HYPER/:
        case /QUERCYNOISE/:
        case /CHARCUT/:
        case /CAMBO DELICES/:
        case /PATISSERIE LOPEZ/:
        case /CASA ITALIA/:
        case /LIDL/:
        case /CARREF/:
        case /BRULERIE/:
        case /ELIOR/:
        case /BIOCOOP/:
        case /CANTINE/:
        case /CHRONO/:
        case /MONOP/:
        case /SPAR/:
        case /BOULANGERIE/:
        case /INTERMARCHE/:
        case /ECOMARCHE/:
        case /INTER PYRENEES/:
        case /LECLERC/:
        case /FRAMBOISINE/:
        case /BISTROT DE JULIE/:
        case /BOUCHER/:
        case /PICARD/:
        case /AUBRAC ALIGOT/:
        case /SOBADIS/:
        case /GRANDEUR NATURE/:
        case /LEADER PRICE/:
        case /REVEL DISCOUNT/: # Leader Price Revel
        case /8 A HUIT/:
        case /SUPER ?U/:
        case /BONNAFOUS/:
        case /VIVAL/:
        case /FOURNIL/:
        case /SIMPLY ROBIN/: # Simply merignac
        case /SUPER MARCHE/:
        case /AUCHAN/:
        case /U EXPRESS/:
        case /ARTISANAT MONAST/:
        case /REVEL NATURE/:
        case /OLIPHEN/: # carrefour deodat
        case /EPI/:
        case /SICA 2 SAVOIE/:
        case /DE CABRIOLE/:
        case /BIO MINIMES/:
        case /FREDERICO REGIS/: # boucherie marché
        case /LES SALOIRS/:
        case /CARMES & NATURE/:
        case /A.C.E.S.A/:
        case /CAS?INO/:     vent="alimentaire"; break

        case /MHAMDI/: # proxi a bagatelle
        case /GAMMA IMMO/:  vent="tocheck"; break

        case /FuJianShengFuZho/:
        case /fuzhoushimaozhou/:     vent="pro"; break

        case /PHILHARMONIE/:
        case /BATEAU PARISIEN/:
        case /BATOBUS/:
        case /PEYRESOURDE/:
        case /TOUR EIFFEL/:
        case /CAMPING/:
        case /POSTE ITALIANE/:
        case /LA SERRE AU CROC/:
        case /PEYRAGUDES/:
        case /ESF CHAMONIX/:
        case /PLANAR/:
        case /HOS?TEL/:     vent="vacances"; break

        case /COMPTOIR LEIA/:
        case /GIFI/:
        case /IKEA/:
        case /MIDICA/:
        case /BOULANGER/:
        case /TOTO/:
        case /HALL DU MENAGER/: # GITEM Revel
        case /Simon Camelet ou Lae/:
        case /age du bois/:
        case /BOUDON/:
        case /HEMA/:        vent="maison"; break

        case /\<CAF\>/:         vent="aides"; break
        case /\<SPB\>/:         vent="banque"; break

        case /GREEN PEACE/:
        case /GREENPEACE/:
        case /AIDES/:       vent="dons"; break

        case /VEOLIA/:
        case /ENERCOOP/:    vent="energie"; break

        case "PAYPAL":      vent="paypal"; break

        case /MINIT/:
        case /MBC/:
        case /TRUFFAUT/:
        case /BOTANIC/:
        case /LAPEYRE/:
        case /FRANS BONHOMME/:
        case /GRDF/:
        case /BERGES/:
        case /LEROY MERLIN/:
        case /BRICOMA/:
        case /POINT P/:
        case /DAUSSION/:
        case /LABEL HABITATION/:
        case "CASTORAMA":   vent="bricolage"; break

        case /SHELL/:
        case /ESSO/:
        case /CTA PURPAN/:
        case /PEUGEOT/:
        case /MONTELIMAR OUEST/:
        case /Autoroutes/:
        case /ASF/:
        case /SNCF/:
        case /AUTOROUTE/:
        case /TOTAL/:
        case /TISSEO/:
        case /SAS AMARYLIS/: # Essence intermarcher
        case /TOULOUSE UTILITA/:
        case /GARAGE/:
        case /RRG/: # Garage Renault
        case /PHALIPPOU/:
        case /BI LAGUNAK/: # Garage Cambo
        case /AUTOSUR/:
        case /NORAUTO/:
        case /FEU VERT/:
        case /STATION/:
        case /ESSFLOREAL/:
        case /RATP/:
        case /IDTGV/:
        case /VELO/:
        case /VELIB/:
        case /CYCLABLE/:
        case /CYCLENVILLCYCLENVILLE/:
        case /VINCI/:
        case /RENTAL/:
        case /RYANAIR/:
        case /BLABLA/:
        case /\<AIRE\>/:
        case /RE\./:
        case /REL\./:
        case /KEOLIS/:
        case /AMENDE RADAR/:
        case /EASYJET/:
        case /AIR FRANCE/: vent="transport"; break

        case /DR CHAMPION/:
        case /DR DURAND ALAIN/:
        case /C\.P\.A\.M\./:
        case /DOCTEUR/:
        case /PARA/:
        case /PHARM/:
        case /PHAR\./:
        case /PHIE/:
        case /PHCIE/:
        case /ANGIOLOGIE/:
        case "PH DES ARENES": vent="santé"; break
    }
    if (vent == "na" && VERBOSE == 1 || VERBOSE == 2)
        switch (cat) {
            case "na":
                print $0
                break
            case "carte":
                printf("%2d/%2d/%2d %10s %10.2f %30s %15s\n", day, month, year, carte_id, amount, description, vent)
                break
            default:
                printf("%2d/%2d/%2d %10s %10.2f %30s %15s\n", day, month, year, cat, amount, description, vent)
                break
            }
    accounts[vent]+=amount
    solde+=amount
}
END{
    for(c in accounts)
        printf("%15s %11.2f\n",c,accounts[c])
    print "solde:"solde
}
