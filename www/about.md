#### Datakilder

Tap av laksefisk (atlantisk laks og regnbueørret) i sjøvannsfasen, fra første utsettsmåned til slakt, rapporteres til Fiskeridirektoratet. Appen er oppdatert med tall per juni 2025. Tap fordeles under kategoriene «dødfisk» (omtalt som «døde» i appen), «utkast fra slakteri» (omtalt som «utkast» i appen), «rømming» og «annet»:

**Dødfisk**: Fisk som er fysisk fjernet fra merden og registrert som død av ulike årsaker. 

**Utkast**: nedgradert fisk sortert ut på slakteriet og ansett som uegnet til humant konsum (f.eks. på grunn av kjønnsmodning, defekter eller lyter). 

**Rømming**: fisk som har rømt på grunn av ulykker. 

**Annet**: Antall fisk som er tapt som følge av predatorer, tyveri, tellefeil og andre årsaker.

Definisjoner er hentet fra, og tilgjengelige på: https://www.fiskeridir.no/statistikk-tall-og-analyse/data-og-statistikk-om-akvakultur/om-statistikk-for-akvakultur  (besøkt 8. august 2025).

Disse tallene danner grunnlaget for tabellene og figurene som presenteres i denne appen. Vær oppmerksom på at dataene og sammendragene kan endres etter hvert som ny informasjon blir tilgjengelig på grunn av rapporteringsforsinkelser, rettelser eller oppdateringer.

#### Databehandling

Denne appen presenterer informasjon om fisketap (se fanen om tapstall) og fiskedødelighet (se dødelighetsfanene). Dataene over tap inkluderer data om all sjøsatt atlantisk laks og regnbueørret, og dekker matfisk (kommersielle tillatelser, stamfisk og fisk under forsknings-, undervisnings- og utviklingstillatelser)
Når det gjelder dødelighetsdataene, er det kun fisk registrert som død som er inkludert i dødelighetsestimatene som presenteres i denne appen (for månedlig-, årlig- og produksjonssyklusdødelighet). Tap rapportert som «utkast», «rømming» eller «annet» er ikke inkludert i disse dødelighetsberegningene. Nedenfor er en oversikt over hvordan dataene behandles for hver tidsperiode:

Når det gjelder dødelighetsdataene, er det kun fisk registrert som død som er inkludert i dødelighetsestimatene som presenteres i denne appen (for månedlig-, årlig- og produksjonssyklusdødelighet). Tap rapportert som «utkast», «rømming» eller «annet» er ikke inkludert i disse dødelighetsberegningene. Nedenfor er en oversikt over hvordan dataene behandles for hver tidsperiode:

- **Månedlig dødelighet** beregnes ved først å estimere dødelighetsraten per lokalitet, som er totalt antall registrerte døde fisk delt på antall fisk som står i fare for å dø («at risk») i løpet av gitt måned. Fordi antallet som står i fare for å dø kan variere gjennom måneden, løses dette ved å benytte gjennomsnittet av antall levende fisk registrert i begynnelsen og slutten av måneden. Denne raten blir deretter konvertert til en dødelighetsrisiko, som representerer sannsynligheten for at en fisk dør i løpet av måneden, ved å bruke formelen beskrevet av andre (Bang Toft et al., 2004; Bang Jensen et al. 2020). Resultatet uttrykkes i prosent (0–100 %). Dødelighetsriskoen er oppsummert fordelt på produksjonsområder, fylker og nasjonalt ved å bruke 25-persentilen (q1), medianen og 75-persentilen (q3) på tvers av lokaliteter.

- **Årlig dødelighet** beregnes ved først å beregne gjennomsnittet av de månedlige dødelighetsratene på lokalitetssnivå på tvers av alle lokaliteter for hver kalendermåned. Disse månedlige gjennomsnittene summeres deretter over en 12-måneders periode for å få den årlige kumulative dødelighetsraten. For å estimere den totale risikoen for at en fisk dør i løpet av året, konverteres denne raten til en årlig kumulativ dødelighetsrisiko ved hjelp av en metode som tar hensyn til hvordan risiko bygger seg opp over tid (Toft et al., 2004; Bang Jensen et al., 2020; Moldal et al., 2025). Resultatet representerer sannsynligheten for at en fisk dør i løpet av et år, uttrykt i prosent fra 0 til 100 %, og rapporteres på produksjonsområde-, fylkes- og nasjonalt nivå.

- **Produksjonssyklusdødelighet** er estimert for lokaliteter der tilgjengelige data indikerer en fullført produksjonssyklus. Det vil si at fiskebeholdning er rapportert uten hull i dataene fra første utsettstidspunkt og frem til slakt, over en periode på minst åtte måneder. Dødelighet beregnes per lokalitet ved å summere de månedlige dødelighetsratene gjennom hele produksjonssyklusens varighet. Denne kumulative raten konverteres deretter til en dødelighetsrisiko ved å bruke samme metode som beskrevet for årlig dødelighet, som tar hensyn til hvordan risiko bygger seg opp over tid (Toft et al., 2004; Bang Jensen et al., 2020; Moldal et al., 2025). Selv om produksjonssykluser kan strekke seg over kalenderår, tilskrives dødelighet året da syklusen slutter (dvs. året fisken ble slaktet). Resultatene er oppsummert ved hjelp av 25-persentilen (q1), medianen og 75-persentilen (q3) av dødelighetsriskoen på lokalitetsnivå og presenteres på produksjonsområde-, fylkes- og nasjonalt nivå.

Månedlige og årlige dødelighetsoppsummeringer inkluderer data fra ulike tillatelser for matfisk (kommersielle tillatelser, stamfisk og fisk under forsknings-, undervisnings- og utviklingstillatelser). For dødelighet i produksjonssyklusen brukes eksklusjonskriterier for å ikke inkludere lokaliteter med kun stamfisk, fisk fra forsknings- og utviklingskonsesjoner og undervisningskonsesjoner.

#### Geografisk område 

Brukere kan velge å se datasammendrag etter **fylke**, **produksjonsområde** eller på **nasjonalt** nivå. Fylkesgrensene gjenspeiler de som er gjeldende fra januar 2024. Produksjonsområdene tilsvarer de 13 områdene som er definert i forskriften (FOR-2017-01-16-61). For å sikre konfidensialitet kan noen fylker eller produksjonsområder med svært få lokaliteter være slått sammen med andre, eller ikke vises separat i visualiseringene. Dataene deres er imidlertid fortsatt inkludert i sammendragene på nasjonalt nivå.

#### Dødelighetskalkulator

Denne appen omfatter også en dødelighetskalkulatorfane designet for å hjelpe brukere med å bruke dødelighetsberegningsmetoden på individuelle lokaliteter over spesifikke eller lengre perioder. Det er imidlertid viktig å merke seg at kalkulatoren ikke er laget for å gjenskape dødelighetssammendragene som vises andre steder i appen. Disse sammendragene er basert på underliggende data på lokalitetsnivå og statistiske aggregeringsmetoder. Forsøk på å reprodusere de ved hjelp av bare kalkulatoren, som er beregnet for bruk på individuelle lokaliteter over brukerdefinerte perioder, vil ikke gi konsistente resultater.

#### Referanser

Bang Jensen, B., Qviller, L., & Toft, N. (2020). Spatio-temporal variations in mortality during the seawater production phase of Atlantic salmon (Salmo salar) in Norway. Journal of Fish Diseases, 43, 445–457.

Ministry of Trade, Industry and Fisheries. (2017). Forskrift om produksjonsområder for akvakultur av matfisk i sjø av laks, ørret og regnbueørret (FOR-2017-01-16-61). Lastet ned fra https://lovdata.no/dokument/SF/forskrift/2017-01-16-61.

Moldal, T., Wiik-Nielsen, J., Oliveira, V. H. S., Svendsen, J. C., & Sommerset, I. (2025). Norwegian Fish Health Report 2024. Norwegian Veterinary Institute Report series #1b/2025. Norwegian Veterinary Institute.

Toft, N., Agger, J. F., Houe, H., & Bruun, J. (2004). Measures of disease frequency. In H. Houe, A. K. Ersbøll, & N. Toft (Eds.), Introduction to Veterinary Epidemiology (pp. 77–93). Frederiksberg, Denmark: Biofolia.

#### Kontakt

Hvis du har spørsmål eller kommentarer til tabellene, diagrammene eller kalkulatoren, kan du kontakte oss på *[VI laksetap app](mailto:laksetap@vetinst.no)*