//= require transit/transit

Transit.configure({
    branding: {
      label: "transit", 
      icon: "truck"
    }, 
    managers: { 
      "Transit.PropertyManager" : { 
        url: null 
      },
      "Transit.AssetManager" : { 
        url: null 
      }
    }
  });

