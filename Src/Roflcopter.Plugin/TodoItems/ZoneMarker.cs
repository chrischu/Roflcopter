﻿using JetBrains.Application.BuildScript.Application.Zones;
using JetBrains.ReSharper.Feature.Services.Navigation;

namespace Roflcopter.Plugin.TodoItems
{
    [ZoneMarker]
    public class ZoneMarker :
            IRequire<NavigationZone> // following JetBrains.ReSharper.Features.Inspections.TodoItems.TodoExplorer
        // IDEA: Also IRequire<IUIInteractiveZone> (if the above isn't enough for InspectCode; what about the tests?)
    {
    }
}
