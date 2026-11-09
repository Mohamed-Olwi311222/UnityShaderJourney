using UnityEngine;
[ExecuteInEditMode]
public class USBReplacementController : MonoBehaviour
{
    public Shader m_replacementShader;
    void OnEnable()
    {
        if (m_replacementShader != null)
        {
            // the camera will replace all the shaders in the scene with the replacement one the “RenderType” configuration must match in both shader
            GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
        }
    }
    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
