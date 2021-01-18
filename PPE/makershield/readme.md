<h1>MakerShield Build!</h1>

The MakerShield is a PAPR style fully filtered face shield.  PAPR stands for Powered Air Purifying Respirator - so this shield has an external fan pack which blows filtered air into the face shield.

![test wear](https://github.com/nova-labs/Nova-I3/blob/master/PPE/makershield/pictures/full%20test.jpg)


<h2> The Shield </h2>
The shield itself is based on Prusa's face shield, but it is sealed with a plastic plenum on top and a wraparound fabric filter around the bottom and sides of the shield.

The fabric wraparound filters the wearer's breath on exhale, and is held to their chin with an elastic band connected to the earpiece of the face shield.  This gives a minimal enclosed area to limit the amount of heat in the face shield.

Up on top of the mask, the plenum includes a port for a standard CPAP hose - this connects the shield to an exernal pack that blows filtered air in to keep the wearer comfortable without exposing them to unfiltered air.

The external filter pack uses a 5v fan - we are evaluating different fans for power - that plugs into a USB powerbank.

On the inlet of the fan is either a cylindrical fabric filter, or an adapter for a P100 puck filter.


<h2> Current Version </h2>
There are three sizes of shield:
 ** headband_novalabs.stl
 ** headband_novalabs_90%.stl
 ** headband_novalabs_80%.stl

They are full size, 90 and 80 percent scale, for younger wearers.  The filter pack is identical, as is the hose.  There are corresponding lasercut files in the lasercut directory.

The shields must be printed out of PETG for the plenum to be flexible enough without breaking - PLA tends to fracture when the thin plenum wall is bent.  It can be replaced or sealed with fabric if that's your only option.
The shield plastic 


<h3>Filter Pack</h3>
The 60mm fan filter pack works much better than the 75mm blower fan, and we are working on an improved filter to get more airflow with a lighter weight.
You need to print: 
 ** finned outlet duct.stl
and either
 ** p95 puck filter.stl OR
 ** cylindrical filter.stl

All of the parts have a strap clip that fits a 1" nylon webbing strap.
Here are the parts we are using:
 ** 5v 6025 (60mm by 25mm) fan: https://smile.amazon.com/gp/product/B08B1CJTMS/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1
 ** 3' CPAP tubing: https://smile.amazon.com/gp/product/B073GBQN73/ref=ppx_yo_dt_b_asin_title_o08_s00?ie=UTF8&psc=1
 ** 1"x48" Nylon Straps: https://smile.amazon.com/gp/product/B088H92PWD/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1
 ** Either: 3M 2071 P95 particulate filter: https://smile.amazon.com/gp/product/B00JE6V22Q/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&psc=1
 **     OR: Merv 13 filter cloth: https://smile.amazon.com/gp/product/B08C9NW62X/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&psc=1
 
 Any USB power bank should work - I got these as a good compromise between size and power:
 ** https://smile.amazon.com/gp/product/B07YB9K7WJ/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1
 
You can substitute any suitable material for the inlet filter on the cylinder - it's got a ton of surface area.

<h2> Assembly </h2>

![All the Parts laid out](https://github.com/nova-labs/Nova-I3/blob/master/PPE/makershield/pictures/assembly%202.jpg)


The fans we linked above include nice long screws - perfect to sandwich the fan, filter and outlet duct.  Make sure the filter and outlet have the belt clip on the same side.


