using UnityEngine;

public class SandController : MonoBehaviour
{
    public CustomRenderTexture Texture;
    public Material SandEffectMaterial;

    public Gradient SandColor;

    private void Start()
    {
        Texture.Initialize();
    }

    private void Update()
    {
        Texture.Update(5);
        
        if (Input.GetMouseButton(0))
        {
            SandEffectMaterial.SetVector("_DrawPosition", Camera.main.ScreenToViewportPoint(Input.mousePosition));
            
            //Color color = SandColor.Evaluate(Mathf.PingPong(Time.time, 1));
            Color color = SandColor.Evaluate(Random.value);
            SandEffectMaterial.SetVector("_DrawColor", color);
        }
        else
        {
            SandEffectMaterial.SetVector("_DrawPosition", -Vector2.one);
        }
    }
}
