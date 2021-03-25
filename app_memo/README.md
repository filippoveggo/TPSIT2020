# APP MEMO

Si vuole realizzare una app di gestione di memo con le seguenti caratteristiche:
- ogni memo ha un titolo ed un corpo in formato md
- ogni memo ha un account Google di riferimento che ne indica il creatore (email Google)
- per un memo ci possono essere più TAG, ad ogni TAG corrisponde almeno un memo, i TAG sono creati eventualmente quando si crea un memo
- un memo può essere condiviso con altri utenti Google

---

## Creazione Server

Per la creazione del server mi sono affidato a Firebase, ed ho usato il suo cloud database Firestore, che usa la tecnica non relazionale ovvero NoSQL.

### I database NoSQL 

I database NoSQL utilizzano una varietà di modelli di dati per accedere e gestire i dati. Questi tipi di database sono ottimizzati specificatamente per applicazioni che necessitano di grandi volumi di dati, latenza bassa e modelli di dati flessibili, ottenuti snellendo alcuni dei criteri di coerenza dei dati degli altri database.

- Flessibilità: i database NoSQL offrono generalmente schemi flessibili che consentono uno sviluppo più veloce e iterativo. Il modello di dati flessibile fa dei database NoSQL la soluzione ideale per i dati semi-strutturati e non strutturati.
- Scalabilità: i database NoSQL in genere sono progettati per il dimensionamento orizzontalmente, attuato usando cluster distribuiti di hardware, invece del dimensionamento verticalmente, che avviene aggiungendo server costosi e di grosse dimensioni. Alcuni fornitori di cloud gestiscono queste operazioni dietro le quinte offrendo un servizio completamente gestito.
- Elevate prestazioni: i database NoSQL sono ottimizzati per modelli di dati specifici e schemi di accesso che consentono prestazioni più elevate rispetto ai risultati che si ottengono cercando di raggiungere una funzionalità simile con i database relazionali.
- Altamente funzionali: i database NoSQL offrono API altamente funzionali e tipi di dati che sono dedicati a ciascuno dei rispettivi modelli di dati.

---

## Database locale

Per il database locale invece la scelta è stata quasi obbligata, quindi ho optato per floor. 

Floor, a differenza di Firestore, è un database relazionale SQLite. 


### Inizializzazione 

*  Per iniziare bisogna creare le entità che rappresenteranno le tabelle del database.
*  Il secondo passo è creare il DAO (Data Access Object), è responsabile della gestione dell'accesso al sottostante database SQLite. La classe DAO contiene le query da fare al database che le ritornerà con un Future o con una Stream.
*  Un'ulteriore cosa da fare è crerare la classe Database che conterrà le entità e il DAO e le metterà insieme. Bisogna ricordarsi di aggiungere *part 'database.g.dart'* che ci servirà per il prossimo punto.
*  L'ultimo passo da fare è runnare il generatore che creerà il vero e proprio database, il comando è *flutter packages pub run build_runner build*.

# Ottimizzazioni 

Una cosa particolare che ho deciso di usare è la Dependency Injection. 

Permette la creazione di oggetti dipendenti al di fuori di una classe e fornisce questi oggetti a una classe attraverso diversi modi. Usando la DI, spostiamo la creazione e il binding degli oggetti dipendenti al di fuori della classe che dipende da loro. Questo porta un più alto livello di flessibilità, disaccoppiamento e test più facili.

In questo caso particolare è stata usata per avere delle dipendenze del database e della repository.

```ruby
final sl = GetIt.instance;

class MemosDI {
  static Future<void> init() async {
    final database =
        await $FloorMemosDatabase.databaseBuilder('memos.db').build();
    sl.registerLazySingleton(() => database);

    sl.registerLazySingleton(() => database.memosDao);

    sl.registerLazySingleton(() => MemosRepository(memosDao: sl()));
  }
}
```

Si è deciso di usare un Signleton perchè il database è univoco.

--- 

Un'altra cosa che ho deciso di implementare è il metodo per non far mai attendere l'utente finchè il sistema fa il login automatico, una volta fatto la prima volta, per fare ciò ho creato la classe *CurrentUser* che tiene conto dello stato dell'utente che prima di aver effettuato il login avrà lo stato iniziale, invece quando l'utente sarà loggato il suo stato cambierà, in particolare *isInitialValue* passerà da *true* a *false*. 

Questo ci permetterà nel main di fare un controllo, e se l'utente dovrà ancora loggarsi lo si rimanderà alla pagina di login, se invece è già loggato lo si rimanda alla SplashScreen e poi quando l'app sarà caricata lo si rimanderà alla HomeScreen.

### CurrentUser 
```ruby
@immutable
class CurrentUser {
  final bool isInitialValue;
  final User data;

  const CurrentUser._(this.data, this.isInitialValue);
  factory CurrentUser.create(User data) => CurrentUser._(data, false);

  static const initial = CurrentUser._(null, true);
}
``` 

### Main

```ruby
return StreamProvider.value(
  value: FirebaseAuth.instance
      .authStateChanges()
      .map((user) => CurrentUser.create(user)),
  initialData: CurrentUser.initial,
  child: Consumer<CurrentUser>(
    builder: (context, user, _) {
      return MaterialApp(
        title: 'App memo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: user.isInitialValue
            ? SplashScreen()
            : user.data != null
                ? HomePage()
                : LoginPage(),
      );
    },
  ),
);
``` 

