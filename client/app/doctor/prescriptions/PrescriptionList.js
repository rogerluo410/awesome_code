import React, { PropTypes, Component } from 'react'
import Loading from '../workspace/Loading'
import PrescriptionForm from './PrescriptionForm'
import PrescriptionItem from './PrescriptionItem'

export default class PrescriptionList extends Component {
  static propTypes = {
    appointmentId: PropTypes.string.isRequired,
    isFetching: PropTypes.bool.isRequired,
    prescriptions: PropTypes.array.isRequired,
    uploadPrescription: PropTypes.func.isRequired,
    fetchPrescriptions: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetchPrescriptions(this.props.appointmentId)
  }

  render() {
    const { uploadPrescription, appointmentId } = this.props
    return (
      <div>
        <h6>Upload prescriptions</h6>
        <div className="prescriptions">
          <PrescriptionForm
            onDrop={uploadPrescription}
            appointmentId={appointmentId}
          />
        </div>
        {renderList(this.props)}
      </div>
    )
  }
}

function renderList(props) {
  // eslint-disable-next-line react/prop-types
  const { isFetching, prescriptions, destroy, appointmentId } = props

  if (isFetching) return <Loading />

  return (
    <div className="u-filescontent">
      {prescriptions.map(pre =>
        <PrescriptionItem
          key={pre.id}
          prescription={pre}
          destroy={destroy}
          appointmentId={appointmentId}
        />
      )}
    </div>
  )
}
