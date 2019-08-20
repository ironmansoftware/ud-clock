function Start-UDClock {
    param($Port = 10000)

    $Dashboard = New-UDDashboard -Title "PowerShell Universal Dashboard Clock" -Content {

        # Use New UDColumn to set the timer. This is a hack and there should be a good "onLoaded" event available
        New-UDColumn -Endpoint {
            while($true) {
                $DateTime = Get-Date
    
                # Update the digital clock with the time string
                Set-UDElement -Id "digital" -Broadcast -Content {$DateTime.ToLongTimeString()}
    
                $Time = $DateTime.TimeOfDay
    
                # Update the second hand of the analog clock
                $x = 100 + 100 * .95 * [Math]::Cos(($Time.Seconds * 6  * [Math]::Pi / 180) -  [Math]::PI / 2)
                $y = 100 + 100 * .95 * [Math]::Sin(($Time.Seconds * 6  * [Math]::Pi / 180) -  [Math]::PI / 2)
                Set-UDElement -Id "seconds" -Broadcast -Attributes @{ x1 = '100'; y1 = '100'; x2 = $x; y2 = $y; style = @{ strokeWidth = '6px'; stroke = 'green'; }}
        
                # Update the minute hand of the analog clock
                $x = 100 + 100 * .85 * [Math]::Cos(($Time.Minutes * 6  * [Math]::Pi / 180) -  [Math]::PI / 2)
                $y = 100 + 100 * .85 * [Math]::Sin(($Time.Minutes * 6  * [Math]::Pi / 180) -  [Math]::PI / 2)
                Set-UDElement -Id "minutes" -Broadcast -Attributes @{ x1 = '100'; y1 = '100'; x2 = $x; y2 = $y; style = @{ strokeWidth = '4px'; stroke = 'blue'; }}
        
                # Update the hour hand of the analog clock
                $x = 100 + 100 * .55 * [Math]::Cos(($Time.Hours * 30  * [Math]::Pi / 180) -  [Math]::PI / 2)
                $y = 100 + 100 * .55 * [Math]::Sin(($Time.Hours * 30  * [Math]::Pi / 180) -  [Math]::PI / 2)
                Set-UDElement -Id "hours" -Broadcast -Attributes @{ x1 = '100'; y1 = '100'; x2 = $x; y2 = $y; style = @{ strokeWidth = '2px'; stroke = 'red'; }}
    
                Start-Sleep -Seconds 1
            }
        }
    
        New-UDRow -Columns {
            New-UDColumn -Size 2 -Content {
                New-UDElement -Tag "div" -Id "analog" -Content {
                    New-UDElement -Tag "svg" -Attributes @{ height = '200'; width = '200'} -Content {
                        New-UDElement -Tag "g" -Content {
                            #Draw the circle for the clock
                            New-UDElement -Tag "circle" -Attributes @{
                                style = @{ stroke = 'black'; fill = '#f8f8f8'}
                                cx = '100'
                                cy = '100'
                                r  = '100'
                            }
    
                            #Draw the hour tick marks for the clock
                            New-UDElement -Tag "line" -Attributes @{ x1 = '100'; y1 = '10'; x2 = '100'; y2 = '0'; style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '150'; y1 = '13'; x2 = '145'; y2 = '22'; style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '187'; y1 = '50'; x2 = '178'; y2 = '55'; style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '190'; y1 = '100'; x2 = '200'; y2 = '100';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '187'; y1 = '150'; x2 = '178'; y2 = '145';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '150'; y1 = '187'; x2 = '145'; y2 = '178';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '100'; y1 = '190'; x2 = '100'; y2 = '200';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '50'; y1 = '187'; x2 = '55'; y2 = '178';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '13'; y1 = '150'; x2 = '22'; y2 = '145';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '0'; y1 = '100'; x2 = '10'; y2 = '100';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '13'; y1 = '50'; x2 = '22'; y2 = '55';  style = @{ stroke = 'black';} }
                            New-UDElement -Tag "line" -Attributes @{ x1 = '50'; y1 = '13'; x2 = '55'; y2 = '22';  style = @{ stroke = 'black';} }
                        }
    
                        # Draw the second, minute and hour hands
                        New-UDElement -Tag "g" -Content {
                            New-UDElement -Id "seconds" -Tag "line" -Attributes @{ x1 = '100'; y1 = '100'; x2 = '100'; y2 = '45'; style = @{ strokeWidth = '6px'; stroke = 'green'; }}
                            New-UDElement -Id "minutes" -Tag "line" -Attributes @{ x1 = '100'; y1 = '100'; x2 = '100'; y2 = '15'; style = @{ strokeWidth = '4px'; stroke = 'blue'; }}
                            New-UDElement -Id "hours" -Tag "line" -Attributes @{ x1 = '100'; y1 = '100'; x2 = '100'; y2 = '5'; style = @{ strokeWidth = '2px'; stroke = 'red'; }}
                        }
                    }
                }
            }
        }
    
        New-UDRow -Columns {
            New-UDColumn -Size 2 -Content {
                New-UDElement -Tag "div" -Id "digital" -Attributes @{ textAlign = "center" }
            }
        }
    } 
    
    Start-UDDashboard -Dashboard $Dashboard -Port $Port
}

