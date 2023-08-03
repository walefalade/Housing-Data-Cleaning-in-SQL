-- Load Data
select *
from NashvilleHousing

-- Data cleaning by standardizing date format
select SaleDate
from NashvilleHousing

select SaleDate, CONVERT(Date, SaleDate)
from NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, convert(Date,SaleDate)
from NashvilleHousing

--fill up property address field
select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking down Address into Address, City and State.
select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAdress Nvarchar(255)

update NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from NashvilleHousing

-- Breaking down OwnerAddress
select OwnerAddress
from NashvilleHousing
where OwnerAddress is not null

select
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)
from NashvilleHousing
where OwnerAddress is not null


alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)

select *
from NashvilleHousing


-- Change Y and N to Yes and No in SoldAsVacant field
select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   END
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   END
from NashvilleHousing


--Removing Duplicates
WITH RowNumCTE AS (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


--data cleaning by deleting unused columns
select *
from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
drop column SaleDate



