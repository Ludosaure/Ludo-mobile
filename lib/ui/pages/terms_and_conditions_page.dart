import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ludo_mobile/data/repositories/administration/terms_and_conditions_repository.dart';
import 'package:ludo_mobile/domain/models/terms_and_conditions.dart';
import 'package:ludo_mobile/ui/components/sized_box_20.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import '../components/custom_back_button.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final TermsAndConditionsRepository _termsAndConditionsRepository =
      TermsAndConditionsRepository();
  final TermsAndConditions _termsAndConditions =
      TermsAndConditionsRepository().getTermsAndConditions();

  TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const CustomBackButton(),
              const SizedBox20(),
              const Text(
                "Conditions générales d'utilisation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Flexible(child: SizedBox(height: 10)),
              Text(
                getLastModified(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF838486),
                ),
              ),
              const SizedBox20(),
              Flexible(
                flex: 35,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // TODO actuellement ce sont les conditions du site web, il faudra les modifier pour les conditions de l'application de location
                      Text(
                        _termsAndConditions.content,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Les présentes Conditions Générales de Vente (dites « CGV ») s’appliquent, sans restriction ni réserve à l’ensemble des ventes conclues par le Vendeur auprès d’acheteurs non professionnels (« Les Clients ou le Client »), désirant acquérir les produits proposés à la vente (« Les Produits ») par le Vendeur sur le site https://www.la-ludosaure.fr
 
Les Produits proposés à la vente sur le site sont les suivants :
Jeux de société, Jeux d’extérieur, Jeux de rôle, Puzzle, Casse-tête, Cartes à collectionner, Accessoires, Jeux d’occasion.
 
Les caractéristiques principales des Produits et notamment les spécifications, illustrations et indications de dimensions ou de capacité des Produits, sont présentées sur le site https://www.la-ludosaure.fr ce dont le client est tenu de prendre connaissance avant de commander.
 
Le choix et l’achat d’un Produit sont de la seule responsabilité du Client.
 
Les offres de Produits s’entendent dans la limite des stocks disponibles, tels que précisés lors de la passation de la commande.
 
Ces CGV sont accessibles à tout moment sur le site https://www.la-ludosaure.fr et prévaudront sur tout autre document.
 
Le client déclare avoir pris connaissance des présentes CGV et les avoir acceptées en cochant la case prévue à cet effet avant la mise en œuvre de la procédure de commande en ligne du site https://www.la-ludosaure.fr
 
Sauf preuve contraire, les données enregistrées dans le système informatique du Vendeur constituent la preuve de l’ensemble des transactions conclues avec le Client.
 
Les coordonnées du Vendeur sont les suivantes :
La Ludosaure, SARL
Capital social de 3 000 euros
Immatriculé au RCS de Rennes, sous le numéro 921462016
2 Bis Boulevard Cahours 35150 Janzé
Email : laludosaure@gmail.com
Téléphone : 02 23 08 02 98
Numéro de TVA Intracommunautaire FR35921462016
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 2 — PRIX",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Les produits sont fournis aux tarifs en vigueur figurant sur le site http://www.la-ludosaure.fr, lors de l’enregistrement de la commande par le Vendeur.
 
Les prix sont exprimés en Euros, HT et TTC.
 
Les tarifs tiennent compte d’éventuelles réductions qui seraient consenties par le Vendeur sur le site https://www.la-ludosaure.fr
 
Ces tarifs sont fermes et non révisables pendant leur période de validité, mais le Vendeur se réserve le droit, hors période de validité, d’en modifier les prix à tout moment.
 
Les prix ne comprennent pas les frais de traitement, d’expédition, de transport et de livraison, qui sont facturés en supplément, dans les conditions indiquées sur le site et calculés préalablement à la passation de la commande.
 
Le paiement demandé au Client correspond au montant total de l’achat, y compris ces frais.
Une facture est établie par le Vendeur et remise au Client lors de la livraison des Produits commandés.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 3 — COMMANDES",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Il appartient au Client de sélectionner sur le site https://www.la-ludosaure.fr les Produits qu’il désire commander, selon les modalités suivantes :
 
Lorsque vous cliquez sur le bouton « Valider votre Commande », vous déclarez accepter pleinement et sans réserve l’intégralité des présentes Conditions générales de vente.
 
Les données enregistrées par La Ludosaure constituent la preuve de l’ensemble des transactions passées par La Ludosaure et ses clients. Les données enregistrées par le système de paiement constituent la preuve des transactions financières.
 
Toute commande qui contrevient à l’usage conforme aux conditions de vente ici énoncées, qui utilise une faille informatique ou exploite le système de fidélité en dehors de son usage standard sera considérée comme nulle et donnera lieu à une annulation et remboursement de notre part.
 
Les offres de Produits sont valables tant qu’elles sont visibles sur le site, dans la limite des stocks disponibles.
La vente ne sera considérée comme valide qu’après paiement intégral du prix. Il appartient au Client de vérifier l’exactitude de la commande et de signaler immédiatement toute erreur.
 
Toute commande passée sur le site https://www.la-ludosaure.fr constitue la formation d’un contrat conclu à distance entre le Client et le Vendeur.
 
Le Vendeur se réserve le droit d’annuler ou de refuser toute commande d’un Client avec lequel il existerait un litige relatif au paiement d’une commande antérieure.
 
Le Client pourra suivre l’évolution de la commande sur le site.
 
Toute annulation de la commande par le Client ne sera possible qu’avant la livraison des Produits (indépendamment des dispositions relatives à l’application ou non du droit de rétractation légal).
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 4 — CONDITIONS DE PAIEMENT",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Le prix est payé par voie de paiement sécurisé, selon les modalités suivantes :
·        Paiement par Paypal
·        Paiement par carte bancaire
 
Le prix est payable comptant par le Client, en totalité au jour de la passation de la commande.
 
Les données de paiement sont échangées en mode crypté grâce au protocole défini par le prestataire de paiement agréé intervenant pour les transactions bancaires réalisées sur le site https://www.la-ludosaure.fr
 
Les paiements effectués par le Client ne seront considérés comme définitifs qu’après encaissement effectif par le Vendeur des sommes dues.
 
Le Vendeur ne sera pas tenu de procéder à la délivrance des Produits commandés par le Client si celui-ci ne lui en paye pas le prix en totalité dans les conditions ci-dessus indiquées.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 5 — LIVRAISONS",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Les Produits commandés par le Client seront livrés en France métropolitaine.
 
Les livraisons interviennent dans un délai de 48 à 72 h à l’adresse indiquée par le Client lors de sa commande sur le site.
 
La livraison est constituée par le transfert au Client de la possession physique ou du contrôle du Produit. Sauf cas particulier ou indisponibilité d’un ou plusieurs Produits, les Produits commandés seront livrés en une seule fois.
 
Le Vendeur s’engage à faire ses meilleurs efforts pour livrer les produits commandés par le Client dans les délais ci-dessus précisés.
 
Si les Produits commandés n’ont pas été livrés dans un délai de 7 jours après la date indicative de livraison, pour toute autre cause que la force majeure ou le fait du Client, la vente pourra être résolue à la demande écrite du Client dans les conditions prévues aux articles L 216-2, L216-3 et L241-4 du Code de la consommation. Les sommes versées par le Client lui seront alors restituées au plus tard dans les quatorze jours qui suivent la date de dénonciation du contrat, à l’exclusion de toute indemnisation ou retenue.
 
Les livraisons sont assurées par un transporteur indépendant, à l’adresse mentionnée par le Client lors de la commande et à laquelle le transporteur pourra facilement accéder.
 
En cas de demande particulière du Client concernant les conditions d’emballage ou de transport des produits commandés, dûment acceptés par écrit par le Vendeur, les coûts liés y feront l’objet d’une facturation spécifique complémentaire, sur devis préalablement accepté par écrit par le Client.
 
Le Vendeur remboursera ou remplacera dans les plus brefs délais et à ses frais, les Produits livrés dont les défauts de conformité ou les vices apparents ou cachés auront été dûment prouvés par le Client, dans les conditions prévues aux articles L 217-4 et suivants du Code de la consommation et celles prévues aux présentes CGV.
 
Le transfert des risques de perte et de détérioration s’y rapportant ne sera réalisé qu’au moment où le Client prendra physiquement possession des Produits. Les Produits voyagent donc aux risques et périls du Vendeur.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 6 — TRANSFERT DE PROPRIÉTÉ",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Le transfert de propriété des Produits du Vendeur au Client ne sera réalisé qu’après complet paiement du prix par ce dernier, et ce quelle que soit la date de livraison desdits Produits.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 7 — DROIT DE RÉTRACTATION",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Selon les modalités de l’article L221-18 du Code de la consommation « Pour les contrats prévoyant la livraison régulière de biens pendant une période définie, le délai court à compter de la réception du premier bien. »
 
Le droit de rétractation peut être exercé en ligne, à l’aide du formulaire de rétractation ci-joint et également disponible sur le site ou de tout autre déclaration, dénuée d’ambiguïté, exprimant la volonté de se rétracter et notamment par courrier postal adressé au Vendeur aux coordonnées postales ou mail indiquées à l’ARTICLE 1 des CGV.
 
Les retours sont à effectuer dans leur état d’origine et complets (emballage, accessoires, notice, etc.) permettant leur recommercialisation à l’état neuf, accompagnés de la facture d’achat.
 
Les Produits endommagés, salis ou incomplets ne sont pas repris.
 
Les frais de retour restant à la charge du Client.
 
L’échange (sous réserve de disponibilité) ou le remboursement sera effectué dans un délai de 14 jours à compter de la réception, par le Vendeur, des Produits retournés par le Client dans les conditions prévues présent article.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 8 — RESPONSABILITÉ DU VENDEUR – GARANTIES",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Les Produits fournis par le Vendeur bénéficient :
·        De la garantie légale de conformité, pour les Produits défectueux, abîmés ou endommagés ou ne correspondant pas à la commande.
·        De la garantie légale contre les vices cachés provenant d’un défaut de matière, de conception ou de fabrication affectant les Produits livrés et les rendant impropres à l’utilisation.
 
Disposition relative aux garanties légales
 
Article L217-4 du Code de la consommation
« Le vendeur est tenu de livrer un bien conforme au contrat et répond des défauts de conformité existant lors de la délivrance. Il répond également des défauts de conformité résultant de l’emballage, des instructions de montage ou de l’installation lorsque celle-ci a été mise à sa charge par le contrat ou a été réalisée sous sa responsabilité. »
 
Article L217-5 du Code de la consommation
« Le bien est conforme au contrat :
1 ° S’il est propre à l’usage habituellement attendu d’un bien semblable et, le cas échéant :
-        S’il correspond à la description donnée par le vendeur et possède les qualités que celui-ci a présentées à l’acheteur sous forme d’échantillon ou de modèle ;
-        S’il présente les qualités qu’un acheteur peut légitiment attendre eu égard aux déclarations publiques faites par le vendeur, par le producteur ou par son représentant, notamment dans la publicité ou l’étiquetage ;
2 ° Ou s’il présente les caractéristiques définies d’un commun accord par les parties ou est propre à tout usage spécial recherché par l’acheteur, porté à la connaissance du vendeur et que ce dernier a accepté. »
 
Article L217-12 du Code de la consommation
« L’action résultant du défaut de conformité se prescrit par deux ans à compter de la délivrance du bien. »
 
Article 1641 du Code civil
« Le vendeur est tenu de la garantie à raison des défauts cachés de la chose venue qui la rendent impropre à l’usage auquel on la destine, ou qui diminuent tellement cet usage, que l’acheteur ne l’aurait pas acquise, ou n’en aurait donné qu’un moindre prix, s’il les avait connus. »
 
Article 1648 alinéa 1er du Code civil
« L’action résultant des vices rédhibitoires doit être intentée par l’acquéreur dans un délai de deux ans à compter de la découverte du vice. »
 
Article L217-16 du Code de la consommation
« Lorsque l’acheteur demande au vendeur, pendant le cours de la garantie commerciale qui lui a été consentie lors de l’acquisition ou de la réparation d’un bien meuble, une remise en état couverte par la garantie, toute période d’immobilisation d’au moins sept jours viennent s’ajouter à la durée de la garantie qui restait à courir. Cette période court à compter de la demande d’intervention de l’acheteur ou de la mise à disposition pour réparation du bien en cause, si cette mise à disposition est postérieure à la demande d’intervention. »
 
Afin de faire valoir ses droits, le Client devra informer le Vendeur par écrit (mail ou courrier), de la non-conformité des Produits ou de l’existence des vices cachés à compter de leur découverte.
 
Le Vendeur remboursera, remplacera ou fera réparer les Produits ou pièces sous garantie jugés non conformes ou défectueux.
 
Les frais d’envoi seront remboursés sur la base du tarif facturé et les frais de retour seront remboursés sur présentation des justificatifs.
 
Les remboursements, remplacements ou réparations des Produits jugés non conformes ou défectueux seront effectués dans les meilleurs délais suivant la constatation par le Vendeur du défaut de conformité ou du vice caché. Ce remboursement pourra être fait par virement ou chèque bancaire.
 
La responsabilité du Vendeur ne saurait être engagée dans les cas suivants :
·        Non-respect de la législation du pays dans lequel les produits sont livrés, qu’il appartient au Client de vérifier
·        En cas de mauvaise utilisation, d’utilisation à des fins professionnelles, négligence ou défaut d’entretien de la part du Client, comme en cas d’usure normale du Produit, d’accident ou de force majeure.
·        Les photographies et graphismes présentés sur le site ne sont pas contractuels et ne sauraient engager la responsabilité du Vendeur.
 
La garantie du Vendeur est, en tout état de cause, limitée au remplacement ou au remboursement des Produits non conformes ou affectés d’un vice.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 9 — DONNÉES PERSONNELLES",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Le Client est informé que la collecte de ses données à caractère personnel est nécessaire à la vente des Produits par le Vendeur ainsi qu’à leur transmission à des tiers à des fins de livraison des Produits. Ces données à caractère personnel sont récoltées uniquement pour l’exécution du contrat de vente.
 
9.1 Collecte des données à caractère personnel
 
Les données à caractère personnel qui sont collectées sur le site https://www.la-ludosaure.fr sont les suivantes :
 
Commande de produits :
 
Lors de la commande de Produit par le Client :
 
Noms, prénoms, adresse postale, numéro de téléphone et adresse e-mail.
Paiement
 
Dans le cadre du paiement des Produits proposés sur le site https://www.la-ludosaure.fr, celui-ci enregistre des données financières relatives au compte bancaire ou à la carte de crédit du Client/utilisateur.
 
9.2 Destinataires des données à caractère personnel
 
Les données à caractère personnel sont réservées à l’usage unique du Vendeur et de ses salariés.
 
9.3 Responsable de traitement
 
Le responsable de traitement des données est le Vendeur, au sens de la loi informatique et liberté et à compter du 25 mai 2018 du Règlement 2016/679 sur la protection des données à caractère personnel.
 
9.4 Limitation du traitement
 
Sauf si le Client exprime son accord exprès, ses données à caractère personnelles ne sont pas utilisées à des fins publicitaires ou marketing.
 
9.5 Durée de conservation des données
 
Le Vendeur conservera les données ainsi recueillies pendant un délai de 5 ans, couvrant le temps de la prescription de la responsabilité civile contractuelle applicable.
 
9.6 Sécurité et confidentialité
 
Le Vendeur met en œuvre des mesures organisationnelles, techniques, logicielles et physiques en matière de sécurité du numérique pour protéger les données personnelles contre les altérations, destructions et accès non autorisés. Toutefois il est à signaler qu’Internet n’est pas un environnement complètement sécurisé et le Vendeur ne peut garantir la sécurité de la transmission ou du stockage des informations sur Internet.
 
9.7 Mise en œuvre des droits des Clients et utilisateurs
 
En application de la réglementation applicable aux données à caractère personnel, les Clients et utilisateurs du site https://www.la-ludosaure.fr disposent des droits suivants :
·        Ils peuvent mettre à jour ou supprimer les données qui les concernent de la manière suivante :
 
En se connectant à son compte, sur l’onglet configuration du compte :
·        Ils peuvent supprimer leur compte en écrivant à l’adresse électronique indiquée à l’article 9.3 « Responsable de traitement »
·        Ils peuvent exercer leur droit d’accès pour connaître les données personnelles les concernant en écrivant à l’adresse indiquée à l’article 9.3 « Responsable de traitement »
·        Si les données à caractère personnel détenues par le Vendeur sont inexactes, ils peuvent demander la mise à jour des informations en écrivant à l’adresse indiquée à l’article 9.3 « Responsable de traitement »
·        Ils peuvent demander la suppression de leurs données à caractère personnel, conformément aux lois applicables en matière de protection des données en écrivant à l’adresse indiquée à l’article 9.3 « Responsable de traitement »
·        Ils peuvent également solliciter la portabilité des données détenues par le Vendeur vers un autre prestataire
·        Enfin, ils peuvent s’opposer au traitement de leurs données par le Vendeur.
 
Ces droits, dès lors qu’ils ne s’opposent pas à la finalité du traitement, peuvent être exercés en adressant une demande par courrier ou par e-mail au Responsable de traitement dont les coordonnées sont indiquées ci-dessus.
 
Le responsable de traitement doit apporter une réponse dans un délai maximum d’un mois.
 
En cas de refus de faire droit à la demande du Client, celui-ci doit être motivé.
 
Le Client est informé qu’en cas de refus, il peut introduire une réclamation auprès de la CNIL (3 places de Fontenoy, 75007 Paris) ou saisir une autorité judiciaire.
 
Le Client peut être invité à cocher une case au titre de laquelle il accepte de recevoir des mails à caractère informatifs et publicitaires de la part du Vendeur. Il aura toujours la possibilité de retirer son accord à tout moment en contactant le Vendeur (coordonnées ci-dessus) ou en suivant le lien de désabonnement.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 10 — PROPRIÉTÉ INTELLECTUELLE",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Le contenu du site https://www.la-ludosaure.fr est la propriété du Vendeur et de ses partenaires et est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.
 
Toute reproduction totale ou partielle de ce contenu est strictement interdite et est susceptible de constituer un délit de contrefaçon.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 11 — DROIT APPLICABLE – LANGUE",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Les présentes CGV et les opérations qui en découlent sont régies et soumises au droit français.
 
Les présentes CGV sont rédigées en langues françaises. Dans le cas où elles seraient traduites en une ou plusieurs langues étrangères, seul le texte français ferait foi en cas de litige.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("ARTICLE 12 — LITIGES",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        """
Pour toute réclamation merci de contacter le service clientèle à l’adresse postale ou mail du Vendeur indiqué à l’ARTICLE 1 des présentes CGV.
 
Le Client est informé qu’il peut, recourir à la plateforme de Règlement en Ligne des Litiges (RLL) : https://ec.europa.eu/consumers/odr/main/index.cfm?event=main.home2.show&lng=FR
 
Tous les litiges auxquels les opérations d’achat et de vente conclues en application des présentes CGV et qui n’auraient pas fait l’objet d’un règlement à l’amiable avec le Vendeur, seront soumis aux tribunaux compétents dans les conditions de droit commun.
                        """,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLastModified() {
    initializeDateFormatting();
    return "edited-at-label".tr(
      namedArgs: {
        "date": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
            .format(_termsAndConditions.lastUpdatedAt),
      },
    );
  }
}
