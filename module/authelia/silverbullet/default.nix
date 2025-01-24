{ pkgs, ... }:

let
  domain = "berge.id";
  hostName = "auth.berge.id";
  silverBulletHostName = "sb.berge.id";
  autheliaConfigFile = pkgs.writeText "authelia-config.yml" ''                                            
    # Authelia configuration in YAML format                                                     
    theme: light                                                                                
                                                                                                
    # Authelia log configuration                                                                
    log:                                                                                        
      level: info                                                                              
                                                                                                
    server:                                                                                     
      timeouts:                                                                                 
        read: 15s                                                                               
        write: 15s                                                                              
        idle: 45s                                                                               
                                                                                                
    # Authelia authentication backend                                                           
    authentication_backend:                                                                     
      file:                                                                                     
        path: /var/lib/authelia-silverbullet/users_database.yml                                 
                                                                                                
                                                                                                
    session:                                                                                    
      ## Cookies configures the list of allowed cookie domains for sessions to be created on.   
      ## Undefined values will default to the values below.                                     
      cookies:                                                                                  
         - domain: '${domain}'
           authelia_url: 'https://${hostName}'                                                
           default_redirection_url: 'https://${silverBulletHostName}'                                       
                                                                                                
    # Authelia storage configuration                                                            
    storage:                                                                                    
      local:                                                                                    
        path: /var/lib/authelia-silverbullet/db.sqlite3                                         
                                                                                                
    # Authelia notifier configuration                                                           
    notifier:                                                                                   
      filesystem:                                                                               
        filename: /var/lib/authelia-silverbullet/notification.txt                               
    '';                                                                                         
in
{
  config = {
    services.authelia = {                                            
      instances = {                                                  
	silverbullet = {                                             
	  settingsFiles = [ autheliaConfigFile ];         
	};                                                           
      };                                                             
    };                                                               
    services.nginx.virtualHosts."${hostName}" = {                  
      enableACME = true;                                             
      forceSSL = true;                                               
      locations = {                                                  
	"/" = {                                                      
	  proxyPass = "http://localhost:9091";                       
	};                                                           
      };                                                             
    };                                                               
    services.ddclient.domains = [ hostName ];

  };
}
