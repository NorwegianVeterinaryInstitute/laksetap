#### Introduksjon
Under denne fanen ("Metodikk") er det gitt presise matematiske formler for de utregningene som presenteres i Laksetap. Dette inkluderer formler for månedlig dødelighet, kumulativ årlig dødelighet og produksjonssyklus dødelighet. Alle disse dødelighetene presenteres som dødelighetsrisiko, ikke dødelighetsrater. Prosedyrerene for datavask og kontroll er ikke inkludert under denne fanen. 

#### Data
Følgende variabler er benyttet som grunnlag for utregningene (engelske variabelnavn i parentes):

- ***lokalitet\_id (site\_id)*** (tekststreng). ID for lokalitet, gitt som en fem siffret kode.
- ***art (species)*** (tekststreng). De to artene som benyttes i Laksetap er "Laks" og "Regnbueørret".
- ***dato (date)*** (dato i YYYY-MM-DD format). Datoen for registreringene. Oppløsningen er månedlig.
- ***døde (dead)*** (integer). Antall fisk registert som dødfisk per lokalitet og måned. I det videre vil $M_{it}$ betegne antall dødfisk registert ved lokalitet $i$ i måned $t$.
- ***i\_risiko (at\_risk)*** (numerisk). Antall fisk som er under risiko for å dø i løpet av en måned, definert som gjennomsnittlig antall fisk i live ved en lokalitet gjennom en måned. I det videre benyttes notasjonen $\overline{N}_{it}$ for antall fisk "i_risk" for lokalitet $i$, måned $t$. Videre er notasjonen $N_{it}$ benyttet for antall fisk i live ved starten av måned $t$ for lokalitet $i$. Følgelig er $N_{i(t+1)}$ antall fisk i live ved starten av påfølgende måned. Antall fisk "i_risiko" er definert som:
  
  $$
  \overline{N}\_{it} = \frac{N\_{it} + N\_{i(t+1)}}{2},
  $$
  
  dvs. gjennomsnittet av antall fisk som var i live ved starten og slutten av måneden, noe man har registeringer for. For den første måneden i produksjonssyklusen, dvs. måneden fisken settes i sjøen antar vi at antall fisk i starten av måneden var null ($N_{it} = 0$). 
  
  *Merk:* $N_{i(t+1)}$ er ikke nødvendigvis gitt ved $N_{it} - M_{it}$, siden fisk kan forsvinne fra lokaliteten av andre årsaker enn at de er registrert som "dødfisk", eksempelvis gjennom rømming, utkast fra slakteri eller andre årsaker.
  
- ***produksjonsområde (area)*** (kategorisk). Produksjonsområde (PO) gitt som 12 nivå ("Norge", "1 & 2", "3", "4", "5", "6", "7", "8", "9", "10", "11" og "12  & 13"). Noen produksjonsområder slås sammen avhengig av datatilgang og krav til minimum antall lokaliter for innsyn via Laksetap. Dette gjelder i særlig grad for rapportering av resultater for regnbueørret. 
- ***fylke (county)*** (kategorisk): Fylker gitt som 8 ulike nivåer ("Norge", "Agder & Rogaland", "Vestland", "Møre og Romsdal", "Trøndelag", "Nordland", "Troms", "Finmark"). Noen fylker slås sammen avhengig av datatilgang og krav til minimum antall lokaliter for innsyn via Laksetap. Dette gjelder i særlig grad for rapportering av resultater for regnbueørret.
- ***måneder\_i\_sjøen (months\_at\_sea)*** (integer): Antall måneder som angjeldende produksjonsyklus har vært i sjøen. Første måned er gitt verdi "1", andre måned verdi "2"  osv. Måneden hvor produksjonssyklusen ble slaktet er gitt verdi "0".

#### Formler

##### Dødelighetsrate
Dødelighetsraten, $\Delta M_{it}$, for ***lokalitet_nr*** $i$ i måned $t$, er definert som forholdet mellom antall dødfisk og antall fisk ***i_risiko***, dvs: 

$$
\Delta M_{it} = \frac{M_{it}}{\overline{N}_{it}} \hspace{10mm} (1)
$$

##### Dødelighetsrisiko
Dødelighetsrisiko, $R_{it}$, for ***lokalitet_nr*** $i$ i måned $t$, er definert som:

$$
R_{it} = 1 - e^{-\Delta M_{it}} \hspace{10mm} (2)
$$

Dødelighetsrate og dødelighetsrisiko henger nøye sammen. Dødelighetsrisiko er en strengt voksende funksjon av dødelighetsrate. For små verdier avviker dødelighetsraten og dødelighetsrisikoen lite fra hverandre. Ved økende dødelighetsrate blir forskjellene tydeligere som vist i figuren under.

*Merk:* Dødelighetsraten $\Delta M_{it}$ er ikke en sannsynelighet og den kan i helt spesielle tilfeller få en verdi større enn 1 (100%). Årsaken til dette er at antall fisk ***i_risiko*** er definert som gjennomsnittet gjennom måneden. De totale tap gjennom måneden kan føre til at antall fisk ***i_risiko*** ($\overline{N_{it}}$) er lavere enn antall ***døde*** ($M_{it}$). 

På den andre siden vil dødelighetsrisikoen, $R_{it}$, alltid bli et tall mellom 0 og 1. Dødelighetsrisikoen kan tolkes som sannsyneligheten en tilfeldig fisk har for å dø (som kategori "dødfisk") i løpet av måneden. 

![Dødelighetsrisiko som funksjon av dødelighetsrate med svart linje. Den røde linjen viser 1:1 forholdet for sammenligning.](rate_vs_risk.png)

##### Kumulativ dødelighetsrisiko
Et avgjørende poeng er at total (kumulativ) dødelighetsrisiko over flere måneder, for ***lokalitet\_nr*** $i$ fra måned $t$ til måned $t + n$, betegnet som  $R^{\mathrm{tot}}_{i,t,t+n}$, kan regnes ut ved hjelp av følgende formel (Bang Jensen, Qviller \& Toft, 2020):

$$
R^{\mathrm{tot}}\_{i,t,t+n} = 1 - \prod\_{k = t}^{t+n}(1 - R_{ik}) = 1 - e^{-\sum_{k = t}^{t+n} \Delta M_{ik}} \hspace{10mm} (3)
$$

Ligning (3) over er egentlig et litt omstendelig utrykk for at månedlige overlevelsesannsynligheter $(1 - \text{risk})$ kan multipliseres til en total/ kumulativ overlevelsessannsynelighet.

#### Månedlig dødelighet

La $\mathit{S}$ betegne en delmengde av lokalitetene som representerer et geografisk nivå dvs. produksjonområde(kombinasjon) eller fylke(kombinasjon). For delmengden $\mathit{S}$ gjennomføres følgende utregninger:

- $n_{St}$: Antall aktive lokaliteter, dvs. lokaliteter som har registreringer for både ***dode*** (dødfisk) og fisk ***i\_risiko*** i måned $t$.
- $M_{it}$ og $R_{it}$ regnes ut for alle lokaliteter i $S$, dvs. for $i = 1, \dots, n_{St}$, basert på ligning (1) og (2). Kun resultatet for dødelighetsrisiko ($R_{it}$) rapporteres i Laksetap.
- Dødelighetsrisikoen rapporteres som percentiler, henholdsvis $\xi^{R_{St}}_{25}$, $\xi^{R_{St}}_{50}$ og $\xi^{R_{St}}_{75}$, dvs 25 %, 50 % (median) og 75 % percentilet for dødelighetsrisikoen for lokalitene i $S$ for de respektive månedene.

*Merk:* Percentilene $\xi^{R_{St}}_{25}$ og $\xi^{R_{St}}_{75}$ representerer variasjon i dødelighetsrisiko mellom lokaliteter. Disse percentilene er ikke forventet å påvirkes systematisk dersom antall lokaliteter ($n_{St}$) endres.

#### Kumulativ årlig dødelighet

##### Utvalg av lokaliteter

La $\mathit{S}_y$ betegne en delmengde av lokalitetene som representerer et geografisk nivå dvs. produksjonområde(kombinasjon) eller fylke(kombinasjon) som har gyldige observasjoner for minst en måned i år $y$.  Kumulativ årlig dødelighet blir regnet ut etter følgende prosedyre:

- ***Steg 1***: Månedlige dødelighetsrater, $\Delta M_{it}$, regnes ut for alle lokaliteter $i \in \mathit{S}_y$ og for alle måneder med gyldige data ut fra ligning (1).

- ***Steg 2***: La $n_{\mathit{S}_{yt}}$ betegne antall lokaliteter i $\mathit{S}_y$ med gyldige data i måned $t$, hvor $t \in y$. Gjennomsnittlig dødelighetsrate i måned $t$ ($\overline{\Delta M}_{\mathit{S}_{yt}}$) regnes da ut som:

$$
\overline{\Delta M}\_{\mathit{S}\_{yt}} = \frac{1}{n\_{\mathit{S}_{yt}}} \sum\_{i \in \mathit{S}\_{yt}} \Delta M\_{it} \hspace{10mm} (4)
$$

- ***Steg 3***: Kumulativ årlig dødelighet frem til måned $t = 1, \ldots, 12$ ($R^{\mathrm{tot}}_{\mathit{S},t}$) regnes ut som:

$$
R^{\mathrm{tot}}\_{\mathit{S},t} = 1 - e^{-\sum\_{k = 1}^{t} \overline{\Delta M}\_{\mathit{S}\_{yk}}} \hspace{10mm} (5)
$$

- ***Steg 4***: Kumulativ årlig dødelighet for alle måneder (dvs. kumulativ/ total dødelighet frem til angjeldende måned), januar til desember, blir rapportert i Laksetap. 

#### Produksjonssyklusdødelighet

##### Gyldige produksjonssykluser

Første steg er å identifisere gyldige produksjonssykluser. Følgende krav må oppfylles:

- Lokaliteten må ha matfisktillatelse. 
- Produksjonssyklusen må være registrert som slaktet, dvs. siste måned må ha verdi "0" for variablen ***måneder\_i\_sjøen***. 
- Produksjonssyklusen må ha gyldige registreringer for variablene ***i\_risiko*** og ***døde*** for alle månedene i syklusen uten manglende data. De gyldige observasjonene må gjelde for en kontinuerlig tidsserie.  
- Produksjonssyklusen må ha vært minst 8 måneder og maksimalt 24 måneder i sjøen. 

##### Utvalg av produksjonssykluser

La $\mathit{S}_y$ betegne en delmengde av gyldige produksjonssykluser (se kulepunkt over) som representerer et geografisk nivå dvs. produksjonområde(kombinasjon) eller fylke(kombinasjon), og som ble slaktet i år $y$. For ulike geografiske nivåer blir de følgende tall beregnet:

- $n_{\mathit{S}_y}$: Totalt antall produksjonssykluser som ble slaktet i år $y$.

- Den kumulative dødelighetsrisikoen, $R^{\mathrm{tot}}_{i,t_{i1},\,t_{i1}+n_i-1}$, for produksjonssyklus $i$ ble regnet ut etter ligning (3). I dette uttrykket representerer $t_{i1}$ den første måneden i sjøen for produksjonssyklus $i$ og $n_i$ er totalt antall måneder produkssjonssyklusen er i sjøen. Både den første måneden i sjøen ($t_{i1}$) og varigheten ($n_i$) kan variere mellom produksjonssykluser, men måneden for slakting, $t_{i1}+n_i-1$, må være en måned i år $y$, slik at produksjonssyklusene blir gruppert etter året de slaktes. 

- I Laksetap rapporteres $\xi^{25}_{R^{\mathrm{tot}}_{\mathit{S}_y}}$, $\xi^{50}_{R^{\mathrm{tot}}_{\mathit{S}_y}}$ og $\xi^{75}_{R^{\mathrm{tot}}_{\mathit{S}_y}}$, dvs. 25 %, 50 % (median) og and 75 % percentiles for kumulativ dødelighetsrisiko for produksjonssykluser som er med i $\mathit{S}_y$.

#### Referanser

Bang Jensen, B., Qviller, L., og Toft, N. (2020). *Spatio-temporal variations in mortality during the seawater production phase of Atlantic salmon (Salmo salar) in Norway*. Journal of Fish Diseases, 43, 445–457.

Toft, N., Agger, J. F., Houe, H., og Bruun, J. (2004). Measures of disease frequency. I H. Houe, A. K. Ersbøll, and N. Toft (Red.), *Introduction to Veterinary Epidemiology* (pp. 77–93). Frederiksberg, Denmark: Biofolia.