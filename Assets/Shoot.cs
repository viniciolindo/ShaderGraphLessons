using System.Collections;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class MouseClickRaycaster : MonoBehaviour
{
    // Distanza massima del raggio (opzionale, default infinito)
    [SerializeField] private float maxDistance = 100f;



    public InputAction mousePressedAction;
    public InputAction mousePositionAction;

    void Start()
    {
       mousePositionAction.Enable();
       mousePressedAction.Enable();
       mousePressedAction.performed += ctx => DetectObject();
    }

    void Update()
    {
       
    }

    void DetectObject()
    {
        // 1. Crea un raggio dalla telecamera verso la posizione del mouse sullo schermo
        Ray ray = Camera.main.ScreenPointToRay(mousePositionAction.ReadValue<Vector2>());
        RaycastHit hit;

        // 2. Lancia il raggio (Physics.Raycast)
        // Se colpisce qualcosa, restituisce true e mette i dati nella variabile 'hit'
        if (Physics.Raycast(ray, out hit, maxDistance))
        {
            // 3. Stampa il nome dell'oggetto colpito
            Debug.Log("Hai cliccato su: " + hit.transform.name);

            if  ( hit.transform.name == "Hades" ) 
            {
                StopAllCoroutines();
                StartCoroutine(hadesFadeOut(hit.transform.GetComponent<Renderer>().material));
                // Esegui azioni specifiche per l'oggetto colpito
                Debug.Log("Hai cliccato sull'oggetto target!");
            }

            // Opzionale: Disegna una linea rossa nella scena per debug (visibile solo nella tab Scene)
            Debug.DrawLine(ray.origin, hit.point, Color.red, 2.0f);
        }
    }
    IEnumerator hadesFadeOut(Material mat)
    {
        while (mat.GetFloat("_DissolveAmount") < 1.0f)
        {
            float currentValue = mat.GetFloat("_DissolveAmount");
            currentValue += Time.deltaTime * 0.5f; // Velocità di dissolvenza
            mat.SetFloat("_DissolveAmount", currentValue);
            yield return null;
        }
        while (mat.GetFloat("_DissolveAmount") >= 0.0f)
        {
            float currentValue = mat.GetFloat("_DissolveAmount");
            currentValue -= Time.deltaTime * 0.5f; // Velocità di dissolvenza
            mat.SetFloat("_DissolveAmount", currentValue);
            yield return null;
        }

    }
}


