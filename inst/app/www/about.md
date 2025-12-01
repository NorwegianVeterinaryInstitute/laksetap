#### Datakilder

Tap av laksefisk (atlantisk laks og regnbueørret) i sjøfasen, dvs. fra første måned etter utsett til slakting, rapporteres månedlig av oppdrettsselskaper til Fiskeridirektoratet. Laksetap appen presenterer resultater basert på de månedlige rapportene fra oppdrettsselskapene til Fiskeridirektoratet. Fra juni 2025 har appen blitt oppdatert kvartalsvis, etter hvert som ny informasjon er tilgjengeliggjort. 
Rådataene er samlet inn på lokalitetsnivå, dvs. per oppdrettsanlegg, og inneholder månedlige beholdnings- og produksjonsrapporter. Dataene er innhentet under en formell avtale hvor det er spesifisert at rådataene ikke er offentlig tilgjengelige. Derfor presenteres kun aggregerte resultater, dvs. samlede resultater for flere lokaliteter, i appen. Resultatene er aggregert på tre geografiske nivåer: fylke, produksjonsområde og nasjonalt nivå.
Fisketap er kategorisert i fire kategorier; dødfisk, utkast fra slakteri, rømming og annet:

- **Dødfisk**: Antall fisk som fysisk er tatt opp. Årsak til denne typen død kan være sykdom, sår, skader etc. uten at årsaken er nærmere spesifisert.
- **Utkast fra slakteri**: Antall fisk som er vraket på slakteriet. Fisken kan være vraket som følge av kjønnsmodning, defekter, lyter, etc.
- **Rømming**: Antall fisk som er rømt i forbindelse med uhell.
- **Annet**: Antall fisk som er tapt som følge av predatorer, tyveri, tellefeil og andre årsaker.

Definisjoner finnes på: https://www.fiskeridir.no/statistikk-tall-og-analyse/data-og-statistikk-om-akvakultur/om-statistikk-for-akvakultur (besøkt 24. november 2025).

Data registrert etter definisjonene over på lokalitetsnivå danner grunnlaget for tabeller og figurer i appen. Merk at tabeller og visualiseringer kan endres etter hvert som ny informasjon blir tilgjengelig, på grunn av rapporteringsforsinkelser, korrigeringer eller oppdateringer.

#### Datavisualisering og tolkning

Appen viser informasjon om **fisketap** (se fanen “*Tapstall*”) og **fiskedødelighet** (se fanene “*Månedlig dødelighet %*”, “*Kumulativ årlig dødelighet %*” og “*Produksjonssyklusdødelighet %*”).

**Fisketap/ Tapstall** inkluderer all sjøutsatt laks og regnbueørret, både matfisk, stamfisk og fisk under forsknings-, utviklings- eller undervisningstillatelser.

**Fiskedødelighetsdata** varierer etter hvordan de er aggregert:

- **Månedlig dødelighet** og **kumulativ årlig dødelighet** inkluderer data fra flere tillatelsestyper (matfisk, stamfisk og fisk under forsknings-, utviklings- eller undervisningstillatelser). 
- **Produksjonssyklusdødelighet** gjelder kun lokaliteter med matfisktillatelser.

Veterinærinstituttet beregner dødelighet i tråd med etablert epidemiologisk praksis. Metoder og prosesser revideres når det er vitenskapelig grunnlag for dette, blant annet for å ta næringens og andre interessenters tilbakemeldinger i betraktning. Oppdateringer dokumenteres og offentliggjøres for transparens.

I den nåværende versjonen av appen kan dødelighetstall vises med ulike mål/ metoder, avhengig av periode eller presentasjonsmodus. Målene/ metodene er tydelig navngitt i appen; men siden de fremdeles ikke benyttes helt konsekvent for ulike perioder, er det viktig å klargjøre betydningen: 

**Median og interkvartilområde (IKO)**: 

Medianen deler observasjonene i to like deler – 50 % av observasjonene er lavere og 50 % er høyere enn medianverdien. IKO viser spredningen til de midterste 50 % av verdiene, ergo er 25% av observasjonene større enn øvre IKO og 25% av observasjonene lavere enn nedre IKO.

**Tolkning**: Median og IKO gir en indikasjon på den “typiske” risikoen og hvor mye den varierer, uten å bli påvirket av ekstreme verdier. Variasjonen gjenspeiler forskjeller mellom lokaliteter innenfor det aggregerte nivået som vises.

**Gjennomsnitt og konfidensintervall (KI)**: 

Gjennomsnittet er det aritmetiske snittet. I tillegg er det oppgitt et 95% konfidensintervall (KI) basert på standardfeil og normaltilnærmelse. KI viser et intervall som med 95% sannsynlighet dekker den sanne forventede gjennomsnittsverdien, dvs. det er en (tilnærmet) 95% sannsynlighet for at dette intervallet dekker den sanne dødeligheten for vedkommende aggregerings nivå (fylke, produksjonsområde eller nasjonalt). Konfidensintervallene blir smalere dersom de er basert på et større antall lokaliteter, og/ eller variasjonen mellom lokalitetene minker. 

**Tolkning**: Gjennomsnitt og KI hjelper med tolkningen av det samlede “sanne” gjennomsnittet og hvor presist estimatet for dette er, siden usikkerheten er eksplisitt kvantifisert. Man vil forvente at observasjoner for enkelt lokaliteter (selv om de ikke offentliggjøres i appen) ofte faller utenfor KI siden intervallet representerer usikkerheten rundt det samlede “sanne” gjennomsnittet, ikke variasjonen for enkeltlokaliteter.

#### Metoder for beregning av dødelighet:


**Månedlig dødelighet**: 

For å beregne månedlig dødelighet beregnes først dødelighetsraten som antall døde fisk (ikke utkast, rømming eller annet) dividert med gjennomsnittlig antall fisk i live, gjennom måneden. Det gjøres en ytterligere antagelse ved at snittet gjennom måneden settes lik snittet av tellingene første og siste dag i måneden. Dødelighetsraten omregnes så til månedlig dødelighet eller dødelighetsrisiko, dvs. “sannsynlighet for å dø i løpet av måneden” med en standard epidemiologisk formel som tar hensyn til hvordan risiko akkumuleres over tid (Toft et al., 2004; Bang Jensen et al., 2020; Moldal et al., 2025). Dødelighetsrisiko uttrykkes som prosent (0-100%) og summeres for produksjonsområde, fylke og på nasjonalt nivå som median og IKO over lokaliteter.

**Kumulativ årlig dødelighet**:  

Som for månedlig dødelighet beregnes kumulativ årlig dødelighet via dødelighetsrater. Gjennomsnittlige månedlige dødelighetsrater beregnes som gjennomsnitt av dødelighetsrater for alle lokaliteter innenfor det gjeldende aggregerte nivået for hver kalendermåned. Disse månedlige gjennomsnittene summeres deretter over månedene for å få en kumulativ dødelighetsrate gjennom hele året eller fra årsstart og fram til registrert måned. De kumulative dødelighetsratene omregnes til en samlet dødelighetsrisiko, dvs. sannsynligheten for at en fisk dør i løpet av det aktuelle året eller den definerte delen av året. Formelen som benyttes er den samme som for månedlig dødelighet. 

Dødelighetsrisikoene som vises i appen, angir sannsynligheten for at en fisk innenfor det aggregerte nivået (produksjonsområde, fylke eller nasjonalt) dør i løpet av det aktuelle året eller valgt dato, uttrykt som prosent (0–100 %). KI-er for forventet samlet årlig dødelighet beregnes for dødelighetsrater basert på standardfeil og normaltilnærming. Disse intervallene omregnes deretter til kumulativ årlig dødelighet ved hjelp av samme standard epidemiologisk formel som beskrevet over. Siden denne transformasjonen er ikke-lineær, blir de resulterende intervallene asymmetriske. For å unngå urealistiske negative verdier settes nedre grense for dødelighetsrate til null før transformasjon. Brede KI indikerer større usikkerhet for den sanne kumulativ årlig dødelighet, noe som typisk oppstår når variasjonen mellom lokaliteter er stor eller når færre observasjoner bidrar til det kumulative estimatet. I visualiseringene representerer nedre KI og øvre KI grensene for 95% KI, dvs. et intervall som med (tilnærmet) 95% sannsynlighet dekker den sanne kumulativ årlig dødelighet.

**Produksjonssyklus dødelighet**:  

Produksjonssyklus dødelighet beregnes basert på lokaliteter hvor data indikerer at en komplett produksjonssyklus er gjennomført. Dette betyr at data fra lokaliteten er rapportert kontinuerlig og uten mangler fra første utsett til endelig slakting, med en varighet på minst 8 måneder og maksimalt 24 måneder. Produksjonssyklus dødeligheten tolkes som sannsynligheten for at en fisk dør i løpet av hele syklusen, beregnes etter samme prinsipp som årlig akkumulert dødelighet, basert på månedlige dødelighetsrater og samme standard epidemiologisk formel. I den nåværende versjonen av appen presenteres produksjonssyklus dødelighet kun som en samlet verdi for hele syklusen og viser ikke måned-for-måned akkumulering, i motsetning til kumulativ årlig dødelighet. Selv om produksjonssykluser kan strekke seg over flere kalenderår, tilskrives produksjonssyklus dødeligheten det året syklusen avsluttes (året for siste slaktehendelse), og ikke nødvendigvis året for utsett, ofte omtalt som generasjonsdødelighet. Resultatene uttrykkes som prosent (0–100 %) og oppsummeres etter produksjonsområde, fylke og nasjonalt nivå, ved bruk av median og IKO på tvers av lokaliteter.

#### Geografiske regioner 

Brukere kan velge visning per fylke, produksjonsområde eller nasjonalt nivå. Fylkesgrenser følger status per januar 2024. Produksjonsområder følger forskrift (FOR-2017-01-16-61). For å sikre konfidensialitet kan områder med få lokaliteter slås sammen eller utelates fra enkelte visninger. Disse vil imidlertid fortsatt være inkludert i sammendragene på nasjonalt nivå.

#### Dødelighetskalkulator

Appen tilbyr også en nedlastbar Excel-basert dødelighetskalkulator, laget for å hjelpe brukere med å anvende metoden for beregning av dødelighet på enkeltlokaliteter i spesifikke eller utvidede perioder (se underfane “*Nedlasting*” under hovedfane “*Om tjenesten*”). Kalkulatoren er ikke laget for å gjenskape dødelighetssammendragene som vises andre steder i appen. Disse sammendragene er basert på underliggende lokalitetsdata og statistiske aggregeringsmetoder. Forsøk på å reprodusere dem ved kun å bruke kalkulatoren, som er beregnet for bruk på enkeltlokaliteter over brukerdefinerte perioder, vil ikke gi konsistente resultater.

#### Nedlastinger

Fanen “*Nedlasting*” under hovedfanen “*Om tjenesten*” inneholder tabeller benyttet i appens visualisering samt dødelighetskalkulatoren. 

#### Referanser

Bang Jensen, B., Qviller, L., og Toft, N. (2020). Spatio-temporal variations in mortality during the seawater production phase of Atlantic salmon (Salmo salar) in Norway. Journal of Fish Diseases, 43, 445–457.

Nærings- og fiskeridepartementet. (2017). Forskrift om produksjonsområder for akvakultur av matfisk i sjø av laks, ørret og regnbueørret (FOR-2017-01-16-61). Hentet fra https://lovdata.no/dokument/SF/forskrift/2017-01-16-61

Moldal T, Wiik-Nielsen J, Oliveira VHS, Svendsen JC og Sommerset I. Fiskehelserapporten 2024, Veterinærinstituttets rapportserie nr. 1a/2025, utgitt av Veterinærinstituttet 2025.

Toft, N., Agger, J. F., Houe, H., og Bruun, J. (2004). Measures of disease frequency. I H. Houe, A. K. Ersbøll, and N. Toft (Red.), Introduction to Veterinary Epidemiology (pp. 77–93). Frederiksberg, Denmark: Biofolia.

#### Kontakt

Hvis du har spørsmål eller kommentarer til tabeller, figurer eller kalkulatorer, vennligst kontakt oss på *[VI laksetap app](mailto:laksetap@vetinst.no)*.