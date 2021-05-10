# App Maree

## UML

Questo è il diagramma uml del progetto
<img src="/images/AppMareeUml.png">

## Struttura del progetto

In questo progetto è stata implementata una versione customizzata della clean architecture.

<img src="https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?resize=556%2C707&ssl=1">


- **Come funziona?**
   Ogni blocco rappresenta una diversa area del software. In generale, più si va in alto, più il software diventa di alto livello.
   Ogni app verrà divisa quindi nelle 3 macroaree: 
   + Presentation:
     Qui ci saranno tutti i widget di cui si avrà bisogno. Questi poi spediscono eventi al Bloc che gestirà i vari stati.
   + Domain:
     Il domain è lo strato più interno che non è suscettibile ai cambiamenti di data source. Conterrà solo la business logic di base (use cases) e gli business objects (entità). Questo livello è totalmente indipendente dagli altri.
   + Data:
     Il livello data consiste in un'implementazione della repository e dalle fonti dei dati - una è di solito da dati remoti (API) e l'altra da un db o dalla cache. La repository è dove si decide se restituire fresh data oppure i dati del db, quando metterli all'interno del db e così via.
## Bloc

Per la gestione dello stato è stato utilizzato Bloc (Business Logic Component) raccomandato dagli stessi sviluppatori di Google. 
<br>
<img src="https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/bloc_architecture_full.png" alt="Bloc Architecture">

Un Bloc è una classe che si basa su eventi per innescare cambiamenti di stato piuttosto che su funzioni. I Bloc ricevono eventi e convertono gli eventi in entrata in stati in uscita.

<br>
<img src="https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/bloc_flow.png" alt="Bloc Flow">
<br>

I cambiamenti di stato in Bloc iniziano quando vengono aggiunti eventi che innescano l'onEvent. Gli eventi sono poi incanalati attraverso transformEvents. Per impostazione predefinita, transformEvents usa asyncExpand per garantire che ogni evento sia processato nell'ordine in cui è stato aggiunto, ma può essere sovrascritto per manipolare il flusso di eventi in entrata. mapEventToState è quindi invocato con gli eventi trasformati ed è responsabile della produzione di stati in risposta agli eventi in entrata. 
Le transizioni sono poi incanalate attraverso transformTransitions che può essere sovrascritto per manipolare i cambiamenti di stato in uscita. Infine, onTransition è chiamato appena prima che lo stato sia aggiornato e contiene lo stato attuale, l'evento e lo stato successivo.

Questo è uno dei Bloc creati nel progetto: 
```dart
class PredictionsWatcherBloc
    extends Bloc<PredictionsWatcherEvent, PredictionsWatcherState> {
  final PredictionRepository predictionRepository;

  PredictionsWatcherBloc({
    @required this.predictionRepository,
  })  : assert(predictionRepository != null),
        super(PredictionsWatcherInitial());

  @override
  Stream<PredictionsWatcherState> mapEventToState(
    PredictionsWatcherEvent event,
  ) async* {
    if (event is PredictionsReceived) {
      yield PredictionsWatcherLoading();
      try {
        final predictions = await predictionRepository.getPredictions();
        yield PredictionsWatcherLoaded(predictions: predictions.data);
      } catch (_) {
        yield PredictionsWatcherFailure();
      }
    }
  }
}
``` 

## Inoltre...
### GroupBy

Per creare le liste dei prossimi giorni, bisognava raggruppare le previsioni di ogni giorno in una mappa, per questo si è usato un metodo del pacchetto *"Collection"*, ovvero **"groupBy"**, vediamo come: 
```dart
Future<Resource<Map<DateTime,List<PredictionDomainModel>>>>
    getPredictionsMap() async {
  try {
    final remotePredictions =
        await predictionsRemoteDatasource.getPredictions();
    final domainModels = remotePredictions
        .map(
          (e) => PredictionDomainModel.fromRemoteModel(e),
        )
        .toList();
    final predictionsMap = groupBy<PredictionDomainModel, DateTime>(
      domainModels,
      (e) => DateTime(
        e.extremeDate.year,
        e.extremeDate.month,
        e.extremeDate.day
      )
    );
    return Resource.success(data: predictionsMap);
  } catch (e) {
    return Resource.failed(error: e);
  }
}
``` 

### Colore e descrizione per ogni valore

Ogni valore della marea ha un suo valore e una sua descrizione per questo, guardando le suddivisioni originali, si è pensato di creare un algoritmo per capire a colpo d'occhio quanto ci dobbiamo preoccupare della marea. 

```dart
static Color getColorFromTideValue(String value) {
  double doubleValue = double.parse(value);
  Color color;
  if (doubleValue <= -90.0) {
    color = Color.fromRGBO(37, 167, 227, 1.0);
  } else if (doubleValue > -90.0 && doubleValue <= -50.0) {
    color = Color.fromRGBO(198, 198, 198, 1.0);
  } else if (doubleValue > -50.0 && doubleValue <= 80.0) {
    color = Color.fromRGBO(54, 188, 83, 1.0);
  } else if (doubleValue > 80.0 && doubleValue <= 110.0) {
    color = Color.fromRGBO(252, 220, 0, 1.0);
  } else if (doubleValue > 110.0 && doubleValue <= 140.0) {
    color = Color.fromRGBO(246, 162, 36, 1.0);
  } else if (doubleValue > 140.0) {
    color = Color.fromRGBO(237, 57, 60, 1.0);
  }
  return color;
}

static String getTideDescriptionFromTideValue(Stringvalue) {
  double doubleValue = double.parse(value);
  String description;
  if (doubleValue <= -90.0) {
    description = "Bassa marea eccezionale";
  } else if (doubleValue > -90.0 && doubleValue <= -50.0) {
    description = "Meno del normale";
  } else if (doubleValue > -50.0 && doubleValue <= 80.0) {
    description = "Normale";
  } else if (doubleValue > 80.0 && doubleValue <= 110.0) {
    description = "Sostenuta";
  } else if (doubleValue > 110.0 && doubleValue <= 140.0) {
    description = "Molto sostenuta";
  } else if (doubleValue > 140.0) {
    description = "Eccezionale";
  }
  return description;
}
``` 
