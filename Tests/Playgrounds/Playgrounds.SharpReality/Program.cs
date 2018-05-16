using System;
using Urho;
using Windows.ApplicationModel.Core;

namespace Playgrounds.SharpReality
{
    internal class Program
	{
		[MTAThread]
		private static void Main() => CoreApplication.Run(
            new UrhoAppViewSource<PerformanceTests>(
                new ApplicationOptions("Data")));
    }
}
