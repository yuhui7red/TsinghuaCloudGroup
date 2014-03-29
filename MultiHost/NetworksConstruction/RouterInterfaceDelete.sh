routerID=$1

subnetID=`neutron router-port-list  $routerID | awk '{ print $8 }' | grep \" | cut -d'"' -f2`

for i  in $subnetID
do
neutron router-interface-delete $routerID $i
done
