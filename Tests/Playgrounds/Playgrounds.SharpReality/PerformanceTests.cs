using Urho;
using Urho.Actions;
using Urho.Shapes;
using Urho.SharpReality;

namespace Playgrounds.SharpReality
{
    public class PerformanceTests : StereoApplication
	{
		private DebugHud hud;

		public PerformanceTests(ApplicationOptions opts) : base(opts)
		{
		}

		protected override void Start()
		{
			base.Start();

            const int size = 15;
            const float scale = 0.05f;
            const float distance = 0.12f;
            for (int i = 0; i < size; i++)
			{
				for (int j = 0; j < size; j++)
				{
					for (int k = 0; k < size; k++)
					{
						var child = Scene.CreateChild();
						child.SetScale(scale);
						var sphere = child.CreateComponent<Box>();
						sphere.Model = ResourceCache.GetModel("Models/Sphere.mdl");
                        sphere.SetMaterial(Material.FromImage("Textures/Earth.jpg"));

                        child.Position = new Vector3(
                            i * distance, j * distance, 1 + k * distance);

                        child.RunActions(new RepeatForever(
                            new RotateBy(
                                duration: 1f,
                                deltaAngleX: 0,
                                deltaAngleY: -5,
                                deltaAngleZ: 0)));
                    }
				}
			}

			Time.FrameEnded += Time_FrameEnded;
			new MonoDebugHud(this) {FpsOnly = true}.Show(Color.Green, 72);

			hud = Engine.CreateDebugHud();
			hud.ToggleAll();
		}

		private void Time_FrameEnded(FrameEndedEventArgs obj)
		{
			var mem1 = hud.MemoryText.Value;
			var mem2 = hud.ModeText.Value;
			var mem3 = hud.ProfilerText.Value;
			var mem4 = hud.StatsText.Value;
		}

		protected override void OnUpdate(float timeStep)
		{
			base.OnUpdate(timeStep);
		}
	}
}
